
#import "QIStatsViewController.h"
#import "QIStoreViewController.h"
#import "QIQuizFactory.h"
#import "QIQuizViewController.h"
#import "QIReachabilityManager.h"

@interface QIStatsViewController ()

@property (nonatomic, strong) QIStatsData *data; 

@end

@implementation QIStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}
-(void)loadView{
  self.view = [[QIStatsView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.title = @"Stats";
}

- (void)viewDidLoad{
  [super viewDidLoad];
  [self.statsView.resetStatsButton addTarget:self action:@selector(resetStats) forControlEvents:UIControlEventTouchUpInside];
  [self.statsView.printStatsButton addTarget:self action:@selector(printStats) forControlEvents:UIControlEventTouchUpInside];
  [self.statsView.summaryView.sorterSegmentedControl addTarget:self action:@selector(sorter:) forControlEvents:UIControlEventValueChanged];
  [self.statsView.summaryView.leastQuizLockButton addTarget:self action:@selector(goToStore:) forControlEvents:UIControlEventTouchUpInside];
  [self.statsView.summaryView.leastQuizButton addTarget:self action:@selector(takeRefreshQuiz) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
  [self.statsView setCurrentRank:[self.data getCurrentRank]];
  [self.statsView setTotalCorrectAnswers:[self.data getTotalCorrectAnswers]];
  [self.statsView setTotalIncorrectAnswers:[self.data getTotalIncorrectAnswers]];
  [self.statsView setConnectionStats:[self.data getConnectionStatsInOrderBy:known ascending:YES]];
  [self.statsView setWellKnownThreshold:[self.data getWellKnownThreshold]];
  [self.statsView.summaryView.pieChartView setDelegate:self];
  [self.statsView.summaryView.pieChartView setDataSource:self];
  [self.statsView.tableView reloadData];
  [self showHideRefreshLockButton]; 
}

- (void)viewDidAppear:(BOOL)animated{
  [self.statsView.summaryView.pieChartView reloadData];
  
  if (self.statsView.totalCorrectAnswers + self.statsView.totalIncorrectAnswers == 0){
    [self noStatsAlert];
  }
}

- (void)resetStats{
  [self.data setUpStats];
}

- (void)printStats{
  [self.data printStats];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
}

#pragma mark Properties

- (QIStatsView *)statsView {
  return (QIStatsView *)self.view;
}

- (void)setParentTabBarController:(UITabBarController *)parentTabBarController{
  _parentTabBarController = parentTabBarController; 
}

- (void)setUserID:(NSString *)userID{
  _userID = userID;
  _data = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  [self.statsView setData:_data];
}

#pragma mark Data Layout

- (void) showHideRefreshLockButton{
  QIIAPHelper *store = [QIIAPHelper sharedInstance];
  BOOL refreshPurchased = [store productPurchased: @"com.kuhlmanation.hobnob.r_pack"];
  [self.statsView.summaryView.leastQuizLockButton setHidden:refreshPurchased];
  [self.statsView.summaryView.leastQuizButton setHidden:!refreshPurchased];
}

#pragma mark Actions

- (void)goToStore:(UIButton *)sender{
  [self.parentTabBarController setSelectedIndex:4];
}

- (void)takeRefreshQuiz{
  if ([QIReachabilityManager isReachable]) {
    QIIAPHelper *store = [QIIAPHelper sharedInstance];
    
    QIQuizQuestionAllowedTypes questionType;
    if ([store productPurchased: @"com.kuhlmanation.hobnob.q_pack"]){
      questionType = QIQuizQuestionAllowAll;
    }
    else {
      questionType = QIQuizQuestionAllowMultipleChoice;
    }
    
    NSArray *refreshPersonIDs = [self.data getRefreshPeopleIDsWithLimit:40];
    if ([refreshPersonIDs count] >= 4){
      [QIQuizFactory quizWithPersonIDs:refreshPersonIDs
                         questionTypes:questionType
                       completionBlock:^(QIQuiz *quiz, NSError *error) {
                         if (error == nil) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                             QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
                             [self presentViewController:quizViewController animated:YES completion:nil];
                           });
                         }
                       }];
    }
    else {
      [self notEnoughRefreshConnectionsAlert]; 
    }

  }
  else{
    [self reachabilityAlert];
  }
}

#pragma mark Alert Functions
- (void)reachabilityAlert{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You must have a connection to the internet to login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

- (void)noStatsAlert {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Stats Yet" message:@"Build up knowledge data by Hobnob'n with your contacts." delegate:self cancelButtonTitle:@"Home" otherButtonTitles:nil];
  [alert show];
}

- (void)notEnoughRefreshConnectionsAlert{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Play More Regular Quizzes" message:@"You need at least 4 people in the \"Needs Refresh\" Category" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
  [self.parentTabBarController setSelectedIndex:0];
}

#pragma mark Pie Chart Delegate

- (NSUInteger)numberOfSlicesInPieChart:(DLPieChart *)pieChart{
  return 3;
}

- (CGFloat)pieChart:(DLPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
  NSArray *chartValues = [self.data getConnectionStatsByKnownGroupings]; 
  NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:
                               [NSNumber numberWithFloat:[[chartValues objectAtIndex:0] count]],
                               [NSNumber numberWithFloat:[[chartValues objectAtIndex:1] count]],
                               [NSNumber numberWithFloat:[[chartValues objectAtIndex:2] count]],
                               nil];
  
  return [[dataArray objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(DLPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *colorArray = [NSMutableArray arrayWithObjects:
                                [UIColor colorWithRed:1.0f green:.71f blue:.20f alpha:1.0f],
                                [UIColor colorWithRed:.34f green:.45f blue:.64f alpha:1.0f],
                                [UIColor colorWithWhite:.33f alpha:1.0f],
                                nil];
  return [colorArray objectAtIndex:index];
}

- (NSString *)pieChart:(DLPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *textArray = [NSMutableArray arrayWithObjects:
                               @"Well",
                               @"Medium",
                               @"Small",
                               nil];
  return [textArray objectAtIndex:index];
}

#pragma mark Factory Methods
- (QIQuizViewController *)newQuizViewControllerWithQuiz:(QIQuiz *)quiz {
  QIQuizViewController *quizViewController = [[QIQuizViewController alloc] initWithQuiz:quiz];
  quizViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  quizViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  return quizViewController;
}

@end
