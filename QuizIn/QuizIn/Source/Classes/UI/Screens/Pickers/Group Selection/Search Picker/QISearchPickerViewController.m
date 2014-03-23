#import "QISearchPickerViewController.h"

#import "QILayoutGuideProvider.h"
#import "LinkedIn.h"
#import "QICompany.h"

@interface QISearchPickerViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, QILayoutGuideProvider>

@property (nonatomic, strong) NSArray *results;

@end

@implementation QISearchPickerViewController

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
  self = [super initWithNibName:nibName bundle:nibBundle];
  if (self) {
    _results = [NSArray array];
  }
  return self;
}

-(void)loadView{
  self.view = [[QISearchPickerView alloc] initWithFrame:CGRectZero layoutGuideProvider:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.searchView.searchBar.delegate = self;
  [self.searchView.searchBar becomeFirstResponder];
  [self.searchView.exitButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  
  self.searchView.tableView.delegate = self;
  self.searchView.tableView.dataSource = self;
}

- (QISearchPickerView *)searchView{
  return (QISearchPickerView *)self.view;
}

#pragma mark TableView Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *cellIdentifier = @"CustomCell";
  QISearchPickerTableViewCell *cell = (QISearchPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QISearchPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  cell.textLabel.text = self.results[indexPath.row];
  return cell;  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSLog(@"Selected Search Result"); 
}

#pragma mark Search Bar Delegate Functions

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  if (searchBar != self.searchView.searchBar) {
    return;
  }
  searchBar.alpha = 0.0f;
  QI_DECLARE_WEAK_SELF(weakSelf);
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

@end
