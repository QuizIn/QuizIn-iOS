

#import "QIGroupSelectionViewController.h"

@interface QIGroupSelectionViewController ()

@end


@implementation QIGroupSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          }
    return self;
}

-(void)loadView{
  self.view = [[QIGroupSelectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  NSMutableArray *selectionContent = [QIGroupSelectionData getSelectionData];
  self.groupSelectionView.selectionContent = selectionContent;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (QIGroupSelectionView *)groupSelectionView {
  return (QIGroupSelectionView *)self.view;
}
@end
