
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
}

- (void)viewWillAppear:(BOOL)animated{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  self.statsView.currentRank = [data getCurrentRank];
  self.statsView.totalCorrectAnswers = [data getTotalCorrectAnswers];
  self.statsView.totalIncorrectAnswers = [data getTotalIncorrectAnswers];
  self.statsView.connectionStats = [data getConnectionStats];
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

- (QIStatsView *)statsView {
  return (QIStatsView *)self.view;
}

@end
