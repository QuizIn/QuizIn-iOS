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
}

- (void)loadView{
  self.view = [[QIRankView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.title = @"Rank";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Properties

- (QIRankView *)rankView {
  return (QIRankView *)self.view;
}

- (void)setParentTabBarController:(UITabBarController *)parentTabBarController{
  _parentTabBarController = parentTabBarController; 
}

@end
