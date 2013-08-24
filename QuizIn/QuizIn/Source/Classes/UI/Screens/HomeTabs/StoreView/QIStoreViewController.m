
#import "QIStoreViewController.h"
#import "QIStoreTableHeaderView.h"
#import "QIStorePreviewViewController.h"

@interface QIStoreViewController ()

@end

@implementation QIStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}
-(void)loadView{
  self.view = [[QIStoreView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.title = @"Store";
  
  
  QIStoreTableHeaderView *tableHeader = (QIStoreTableHeaderView *)self.storeView.tableView.tableHeaderView; 
  [tableHeader.buyAllButton addTarget:self action:@selector(buyAll) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buyAll{
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
  previewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
  [self presentViewController:previewController  animated:YES completion:nil];
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
