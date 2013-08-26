
#import "QISearchPickerViewController.h"

@interface QISearchPickerViewController ()

@end

@implementation QISearchPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)loadView{
  [self setView:[[QISearchPickerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
  [self.searchView.searchBar setDelegate:self];
  [self.searchView.searchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)dismissSearch{
  [self dismissViewControllerAnimated:NO completion:nil];
}

- (QISearchPickerView *)searchView{
  return (QISearchPickerView *)self.view;
}

#pragma mark Search Bar Delegate Functions
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
  [self dismissViewControllerAnimated:YES completion:nil]; 
}


@end
