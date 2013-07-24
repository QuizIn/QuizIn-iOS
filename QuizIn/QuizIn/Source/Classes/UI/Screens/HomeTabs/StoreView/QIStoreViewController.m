
#import "QIStoreViewController.h"

@interface QIStoreViewController ()

@end

@implementation QIStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView{
  self.view = [[QIStoreView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.title = @"Store";
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

- (QIStoreView *)storeView {
  return (QIStoreView *)self.view;
}

@end
