
#import "QISchoolSearchPickerViewController.h"

@interface QISchoolSearchPickerViewController ()

@property (nonatomic, strong) NSArray *results;

@end

@implementation QISchoolSearchPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar != self.searchView.searchBar) {
        return;
    }
    searchBar.alpha = 0.0f;
    QI_DECLARE_WEAK_SELF(weakSelf);
    
    //TODO rkuhlman search for school instead
    
    [LinkedIn
     searchForCompaniesWithName:searchBar.text
     withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:^(NSArray *companies, NSError *error) {
         weakSelf.searchView.searchBar.alpha = 1.0f;
         if (!companies || [companies count] == 0) {
             return;
         }
         NSMutableArray *searchResults = [NSMutableArray arrayWithCapacity:[companies count]];
         for (QICompany *company in companies) {
             [searchResults addObject:company.name];
         }
         weakSelf.results = [searchResults copy];
         dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf.searchView.tableView reloadData];
         });
     }];
}

-(void)dismiss{
  [self dismissViewControllerAnimated:YES completion:nil];
}


@end
