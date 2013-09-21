
#import "QIStatsViewController.h"

@interface QIStatsViewController ()

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
}

- (void)viewWillAppear:(BOOL)animated{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  self.statsView.currentRank = [data getCurrentRank];
  self.statsView.totalCorrectAnswers = [data getTotalCorrectAnswers];
  self.statsView.totalIncorrectAnswers = [data getTotalIncorrectAnswers];
  self.statsView.connectionStats = [data getConnectionStatsInOrderBy:lastName];
  [self.statsView.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
  [self.statsView.summaryView.pieChartView reloadData];
  
  if (self.statsView.totalCorrectAnswers + self.statsView.totalIncorrectAnswers == 0){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Stats Yet" message:@"Build up knowledge data by Hobnob'n with your contacts." delegate:self cancelButtonTitle:@"Home" otherButtonTitles:nil];
    [alert show];
  }
}

- (void)sorter:(id)sender{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  UISegmentedControl *sorter = (UISegmentedControl *)sender;
  int index = [sorter selectedSegmentIndex];
  switch (index) {
    case 0:{
      self.statsView.connectionStats = [data getConnectionStatsInOrderBy:firstName];
      [self.statsView.tableView reloadData];
      break;
    }
    case 1:{
      self.statsView.connectionStats = [data getConnectionStatsInOrderBy:lastName];
      [self.statsView.tableView reloadData];
      break;
    }
    case 2:{
      self.statsView.connectionStats = [data getConnectionStatsInOrderBy:knowledgeIndex];
      [self.statsView.tableView reloadData];
      break;
    }
    default:
      break;
  }
}

- (void)resetStats{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  [data setUpStats];
}

- (void)printStats{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  [data printStats];
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

#pragma mark UIAlertViewDelegate Functions
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
  [self.parentTabBarController setSelectedIndex:0];
}

@end
