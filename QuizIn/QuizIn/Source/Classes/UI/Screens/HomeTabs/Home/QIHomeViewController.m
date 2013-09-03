#import "QIHomeViewController.h"
#import "QIQuizViewController.h"
#import "QIGroupSelectionViewController.h"
#import "LinkedIn.h"
#import "QIHomeView.h"


#define MAX_TIMED_IMAGES 4

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
  [LinkedIn numberOfConnectionsForAuthenticatedUserOnCompletion:^(NSInteger numberOfConnections, NSError *error) {
    if (error == nil) {
      NSLog(@"Number of Connections: %d", numberOfConnections);
      self.homeView.numberOfConnections = numberOfConnections;
    } else {
      NSLog(@"Error: %@", error);
    }
  }];
}

- (void)viewWillAppear:(BOOL)animated{
  [self.view updateConstraintsIfNeeded]; 
  self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                target:self
                                              selector:@selector(timedImageChange)
                                              userInfo:nil
                                               repeats:YES];
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
                                         action:@selector(groupPicker)
                               forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.localeQuizLockButton addTarget:self
                                      action:@selector(groupPicker)
                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.industryQuizLockButton addTarget:self
                                      action:@selector(groupPicker)
                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.groupQuizLockButton addTarget:self
                                      action:@selector(groupPicker)
                            forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions

- (void)startConnectionsQuiz:(id)sender {
  QIQuizViewController *quizViewController = [self newQuizViewController];
  [self presentViewController:quizViewController animated:YES completion:nil];
}

- (void)groupPicker{
  QIGroupSelectionViewController *groupSelectionViewController = [self newGroupSelectionViewController];
  [self presentViewController:groupSelectionViewController animated:YES completion:nil];
}

#pragma mark Data
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

#pragma mark Factory Methods

- (QIQuizViewController *)newQuizViewController {
  QIQuizViewController *quizViewController = [[QIQuizViewController alloc] init];
  quizViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  quizViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  return quizViewController;
}

- (QIGroupSelectionViewController *)newGroupSelectionViewController {
  QIGroupSelectionViewController *groupSelectionViewController = [[QIGroupSelectionViewController alloc] init];
  groupSelectionViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  groupSelectionViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  groupSelectionViewController.view.frame = self.view.bounds;
  return groupSelectionViewController;
}

@end
