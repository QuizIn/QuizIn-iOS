#import "QIRankViewController.h"
#import "QIStatsData.h"

@interface QIRankViewController ()

@end

@implementation QIRankViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
  QIStatsData *stats = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  self.rankView.rank = [NSString stringWithFormat:@"%d",[stats getCurrentRank]];
  [self.rankView.rankDisplayView.exitButton addTarget:self.rankView action:@selector(hideRankDisplay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillDisappear:(BOOL)animated{
  [self.rankView.scrollView setContentOffset:CGPointMake(0,0)];
}

- (void)loadView{
  self.view = [[QIRankView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Properties

- (QIRankView *)rankView {
  return (QIRankView *)self.view;
}

- (void)setParentTabBarController:(UITabBarController *)parentTabBarController{
  _parentTabBarController = parentTabBarController; 
}

- (void)setUserID:(NSString *)userID {
  _userID = userID;
  [self updateUserID];
}

#pragma mark Actions
- (void) updateUserID{
  self.rankView.userID = self.userID; 
}

@end
