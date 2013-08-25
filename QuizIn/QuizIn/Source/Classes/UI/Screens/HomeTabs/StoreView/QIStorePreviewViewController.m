
#import "QIStorePreviewViewController.h"

@interface QIStorePreviewViewController ()

@end

@implementation QIStorePreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
  self.view = [[QIStorePreviewView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.previewView.exitButton addTarget:self action:@selector(dismissPreview) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissPreview{
  [self dismissViewControllerAnimated:NO completion:nil]; 
}
   
- (QIStorePreviewView *)previewView{
  return (QIStorePreviewView *)self.view;
}

@end
