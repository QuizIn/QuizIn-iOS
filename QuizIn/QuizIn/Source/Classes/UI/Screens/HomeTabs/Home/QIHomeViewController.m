
#import "QIHomeViewController.h"
#import "QIQuizViewController.h"
#import "QIGroupSelectionViewController.h"
#import "QILocationSelectionViewController.h"
#import "QISchoolSelectionViewController.h"
#import "QIIndustrySelectionViewController.h"
#import "QICompanySelectionViewController.h"
#import "QIStoreViewController.h"
#import "LinkedIn.h"
#import "QIIAPHelper.h"
#import "QIStoreData.h"
#import "QIHomeView.h"
#import "QIQuizFactory.h"

//todo kill these
#import "QIQuizFinishViewController.h"
#import "QILoginScreenViewController.h" 

#define MAX_TIMED_IMAGES 4

typedef NS_ENUM(NSInteger, QIFilterType) {
  QIFilterTypeNone,
  QIFilterTypeCompany,
  QIFilterTypeLocation,
  QIFilterTypeSchool,
  QIFilterTypeIndustry,
};

@interface QIHomeViewController ()
@property(nonatomic, strong, readonly) QIHomeView *homeView;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) NSInteger timedImageCount;
@end

@implementation QIHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)loadView {
  self.view = [[QIHomeView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  /*[LinkedIn numberOfConnectionsForAuthenticatedUserOnCompletion:^(NSInteger numberOfConnections, NSError *error) {
    if (error == nil) {
      NSLog(@"Number of Connections: %d", numberOfConnections);
      self.homeView.numberOfConnections = numberOfConnections;
    } else {
      NSLog(@"Error: %@", error);
    }
  }];*/
}

- (void)viewWillAppear:(BOOL)animated{
  [self.view updateConstraintsIfNeeded]; 
  self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                target:self
                                              selector:@selector(timedImageChange)
                                              userInfo:nil
                                               repeats:YES];
  [self showHideLockButtons]; 
}

- (void)viewWillDisappear:(BOOL)animated{
  [self.homeView.scrollView setContentOffset:CGPointMake(0, 0)]; 
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.timedImageCount = 0;
  
  [self.homeView setImageURLs:[self getFourRandomURLs]];
 /// [self.homeView setImageURLs:@[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_80_80/p/1/000/080/035/28eea75.jpg"],[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_80_80/p/1/000/080/035/28eea75.jpg"],[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_80_80/p/1/000/080/035/28eea75.jpg"],[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_80_80/p/1/000/080/035/28eea75.jpg"]]];
  
  [self.homeView.connectionsQuizButton addTarget:self
                                          action:@selector(startConnectionsQuiz:)
                                forControlEvents:UIControlEventTouchUpInside];

  [self.homeView.companyQuizLockButton addTarget:self
                                         action:@selector(goToStore:)
                               forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.localeQuizLockButton addTarget:self
                                      action:@selector(goToStore:)
                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.industryQuizLockButton addTarget:self
                                      action:@selector(goToStore:)
                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.groupQuizLockButton addTarget:self
                                      action:@selector(goToStore:)
                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.companyQuizBeginButton addTarget:self
                                           action:@selector(groupPicker:)
                                 forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.localeQuizBeginButton addTarget:self
                                          action:@selector(groupPicker:)
                                 forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.industryQuizBeginButton addTarget:self
                                            action:@selector(groupPicker:)
                                 forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.groupQuizBeginButton addTarget:self
                                         action:@selector(groupPicker:)
                                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions

- (void)startConnectionsQuiz:(id)sender {
  [QIQuizFactory quizFromRandomConnectionsWithCompletionBlock:^(QIQuiz *quiz, NSError *error) {
    if (error == nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
        [self presentViewController:quizViewController animated:YES completion:nil];
      });
    }
  }];
}

- (void)goToStore:(UIButton *)sender{
  [self.parentTabBarController setSelectedIndex:4];
}

- (void)groupPicker:(UIButton *)sender{
  QIFilterType type = QIFilterTypeNone;
  if (sender == self.homeView.companyQuizBeginButton) {
    type = QIFilterTypeCompany;
  } else if (sender == self.homeView.industryQuizBeginButton) {
    type = QIFilterTypeIndustry;
  } else if (sender == self.homeView.localeQuizBeginButton) {
    type = QIFilterTypeLocation;
  } else if (sender == self.homeView.groupQuizBeginButton) {
    type = QIFilterTypeSchool;
  }
  
  QIGroupSelectionViewController *groupSelectionViewController = [self newGroupSelectionViewControllerForType:type];
  [self presentViewController:groupSelectionViewController animated:YES completion:nil];
}

//Todo Test Quiz Finish View
- (void)showQuizFinish{
  QIQuizFinishViewController *finishViewController = [[QIQuizFinishViewController alloc] init];
  [self presentViewController:finishViewController animated:YES completion:nil];
}
- (void)showLoginScreen{
  QILoginScreenViewController *loginScreenViewController = [[QILoginScreenViewController alloc] init];
  [self presentViewController:loginScreenViewController animated:YES completion:nil];
}


#pragma mark Data
- (void) showHideLockButtons{
  QIIAPHelper *store = [QIIAPHelper sharedInstance];
  BOOL filterPurchased = [store productPurchased: @"com.kuhlmanation.hobnob.f_pack"];
  [self.homeView.companyQuizLockButton setHidden:filterPurchased];
  [self.homeView.companyQuizBeginButton setHidden:!filterPurchased];
  [self.homeView.localeQuizLockButton setHidden:filterPurchased];
  [self.homeView.localeQuizBeginButton setHidden:!filterPurchased];
  [self.homeView.industryQuizLockButton setHidden:filterPurchased];
  [self.homeView.industryQuizBeginButton setHidden:!filterPurchased];
  [self.homeView.groupQuizLockButton setHidden:filterPurchased];
  [self.homeView.groupQuizBeginButton setHidden:!filterPurchased];
}

- (NSArray *)getFourRandomURLs{
  
  //TODO Fix this to not be test data
  NSArray *set = @[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_60_60/p/3/000/2b1/283/2147fda.jpg"],
                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_60_60/p/3/000/066/207/0190cd3.jpg"],
                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_60_60/p/1/000/2a9/318/3d37ffa.jpg"],
                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_60_60/p/2/000/193/24d/3b15220.jpg"],
                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_60_60/p/1/000/05a/1f3/1118b2a.jpg"],
                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_60_60/p/4/000/174/143/2dacb5e.jpg"]];
  NSMutableArray *testArray = [NSMutableArray array];
  for (int i=0; i<4; i++) {
    int randomIndex = arc4random_uniform(5);
    [testArray addObject:[set objectAtIndex:randomIndex]];
  }

  return [testArray copy];
}

- (void)timedImageChange{
  self.timedImageCount++;
  self.homeView.imageURLs = [self getFourRandomURLs];
  if (self.timedImageCount >= MAX_TIMED_IMAGES) {
    [self.timer invalidate];
  }
}
#pragma mark Strings

- (NSString *)homeScreenTitle {
  return @"Home";
}
   
#pragma mark Properties

- (QIHomeView *)homeView {
  return (QIHomeView *)self.view;
}

- (void)setParentTabBarController:(UITabBarController *)parentTabBarController {
  _parentTabBarController = parentTabBarController; 
}

#pragma mark Factory Methods

- (QIQuizViewController *)newQuizViewControllerWithQuiz:(QIQuiz *)quiz {
  QIQuizViewController *quizViewController = [[QIQuizViewController alloc] initWithQuiz:quiz];
  quizViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  quizViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  return quizViewController;
}

- (QIGroupSelectionViewController *)newGroupSelectionViewControllerForType:(QIFilterType)type {
  QIGroupSelectionViewController *groupSelectionViewController = nil;
  
  switch (type) {
    case QIFilterTypeCompany:
      groupSelectionViewController = [[QICompanySelectionViewController alloc] init];
      break;
      
    case QIFilterTypeLocation:
      groupSelectionViewController = [[QILocationSelectionViewController alloc] init];
      break;
      
    case QIFilterTypeSchool:
      groupSelectionViewController = [[QISchoolSelectionViewController alloc] init];
      break;
      
    case QIFilterTypeIndustry:
      groupSelectionViewController = [[QIIndustrySelectionViewController alloc] init];
      break;
      
    case QIFilterTypeNone:
      // Do nothing.
      break;
  }
  groupSelectionViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  groupSelectionViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  groupSelectionViewController.view.frame = self.view.bounds;
  return groupSelectionViewController;
}

@end
