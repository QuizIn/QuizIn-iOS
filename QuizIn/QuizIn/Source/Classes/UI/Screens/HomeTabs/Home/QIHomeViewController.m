
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
#import "QIConnectionsStore.h"
#import "QIPerson.h"
#import "QIReachabilityManager.h"


//todo kill these
#import "QIQuizFinishViewController.h"
#import "QILoginScreenViewController.h" 

#define MAX_TIMED_IMAGES 30

typedef NS_ENUM(NSInteger, QIFilterType) {
  QIFilterTypeNone,
  QIFilterTypeCompany,
  QIFilterTypeLocation,
  QIFilterTypeSchool,
  QIFilterTypeIndustry,
};

@interface QIHomeViewController ()
@property (nonatomic, strong, readonly) QIHomeView *homeView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timedImageCount;
@property (nonatomic, strong) NSMutableArray *randomPicURLs;
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
  if ([QIReachabilityManager isReachable]){
    self.view = [[QIHomeView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [LinkedIn numberOfConnectionsForAuthenticatedUserOnCompletion:^(NSInteger numberOfConnections, NSError *error) {
      if (error == nil) {
        self.homeView.numberOfConnections = numberOfConnections;
      } else {
        NSLog(@"Error: %@", error);
      }
    }];
    
    self.randomPicURLs = [NSMutableArray array];
    [LinkedIn randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:30 onCompletion:^(QIConnectionsStore *connectionsStore, NSError *error) {
      if (error == nil){
        NSSet *personIDs = connectionsStore.personIDsWithProfilePics;
        for (NSString *personID in personIDs ){
          QIPerson *person = connectionsStore.people[personID];
          NSURL *personPicURL = [NSURL URLWithString:person.pictureURL];
          [self.randomPicURLs addObject:personPicURL];
        }
      }
    }];
  }
  else {
    [self connectionAlert]; 
  }
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:NO];
  [self.view updateConstraintsIfNeeded];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                target:self
                                              selector:@selector(timedImageChange)
                                              userInfo:nil
                                               repeats:YES];
  [self showHideLockButtons]; 
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:NO];
  [self.homeView.scrollView setContentOffset:CGPointMake(0, 0)]; 
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.timedImageCount = 0;
  
  [self.homeView setImageURLs:[self getFourRandomURLs]];
  
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
  if ([QIReachabilityManager isReachable]){
    QIIAPHelper *store = [QIIAPHelper sharedInstance];
    
    QIQuizQuestionAllowedTypes questionTypes;
    if ([store productPurchased: @"com.kuhlmanation.hobnob.q_pack"] || [store productPurchased:@"com.kuhlmanation.hobnob.p_kit"]){
      questionTypes = QIQuizQuestionAllowAll;
    }
    else {
      questionTypes = QIQuizQuestionAllowMultipleChoice;
    }
    
    [QIQuizFactory
     quizFromRandomConnectionsWithQuestionTypes:questionTypes
     completionBlock:^(QIQuiz *quiz, NSError *error) {
       if (error == nil) {
         dispatch_async(dispatch_get_main_queue(), ^{
           QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
           [self presentViewController:quizViewController animated:YES completion:nil];
         });
       }
       else {
         [self peopleAlert];
       }
     }];
  }
  else {
    [self connectionAlert]; 
  }
}

- (void)goToStore:(UIButton *)sender{
  [self.parentTabBarController setSelectedIndex:4];
}

- (void)groupPicker:(UIButton *)sender{
  if ([QIReachabilityManager isReachable]) {
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
  else {
    [self connectionAlert];
  }
  
}

- (void)connectionAlert{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dand Ole Internet" message:@"You gotta have a good connection to the internet to login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

- (void)peopleAlert{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Peeps Needed" message:@"You gotta have at least 4 connections to create a quiz - any less and you should just peep their profiles." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

#pragma mark Data
- (void) showHideLockButtons{
  QIIAPHelper *store = [QIIAPHelper sharedInstance];
  BOOL filterPurchased = [store productPurchased: @"com.kuhlmanation.hobnob.f_pack"] || [store productPurchased:@"com.kuhlmanation.hobnob.p_kit"];
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
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"placeholderHead" ofType:@"png"];
  NSURL *url = [NSURL fileURLWithPath:path];
  
  NSMutableArray *testArray = [NSMutableArray arrayWithObjects:
                               url,url,url,url, nil];
  
  NSArray *set = self.randomPicURLs;
  if ([set count]>0){
    for (int i=0; i<4; i++) {
      int randomIndex = arc4random_uniform([set count]);
      [testArray replaceObjectAtIndex:i withObject:[set objectAtIndex:randomIndex]];
    }
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
