
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
}

- (void)viewDidLoad{
  [super viewDidLoad];
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:@"12345"];
  self.statsView.currentUser = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"12345", @"userID",
                                @"Rick", @"userFirstName",
                                @"Kuhlman", @"userLastName",
                                nil];
  self.statsView.currentRank = [data getCurrentRank];
  self.statsView.totalCorrectAnswers = [data getTotalCorrectAnswers];
  self.statsView.totalIncorrectAnswers = [data getTotalIncorrectAnswers];
  self.statsView.connectionStats = [data getConnectionStats];
  
  [self.statsView.resetStatsButton addTarget:self action:@selector(resetStats) forControlEvents:UIControlEventTouchUpInside];
  [self.statsView.printStatsButton addTarget:self action:@selector(printStats) forControlEvents:UIControlEventTouchUpInside];
  [self.statsView.addStatsButton addTarget:self action:@selector(addStats) forControlEvents:UIControlEventTouchUpInside];
}

- (void)resetStats{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:@"12345"];
  [data setUpStats];
}

- (void)printStats{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:@"12345"];
  [data printStats];
}

- (void)addStats{
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:@"12345"];
  NSDictionary *profile = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"0005", @"userID",
                           @"Bob", @"userFirstName",
                           @"Scoma", @"userLastName",
                           nil];
  [data updateStatsWithConnectionProfile:profile correct:YES]; 
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
