
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
