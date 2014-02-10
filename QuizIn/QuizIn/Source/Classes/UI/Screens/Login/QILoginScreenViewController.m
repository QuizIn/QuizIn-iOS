
#import "QILoginScreenViewController.h"
#import "QIApplicationViewController.h"

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
  self.view = [[QILoginScreenView alloc] init];
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.loginScreenView.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}

- (void)login{
  
  QIApplicationViewController *applicationViewController = [QIApplicationViewController new];
  [self addChildViewController:applicationViewController];
  [self.view addSubview:applicationViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QILoginScreenView *)loginScreenView {
  return (QILoginScreenView *)self.view;
}

@end
