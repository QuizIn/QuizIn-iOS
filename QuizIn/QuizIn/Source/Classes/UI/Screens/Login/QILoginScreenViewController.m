
#import "QILoginScreenViewController.h"
#import "QIStatsViewController.h"


@interface QILoginScreenViewController ()

@end


@implementation QILoginScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
  self.view = [[QILoginScreenView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.loginScreenView.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)login{
 [self.appViewController login];
}

- (QILoginScreenView *)loginScreenView {
  return (QILoginScreenView *)self.view;
}

@end
