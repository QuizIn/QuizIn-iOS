
#import "QISearchPickerViewController.h"

@interface QISearchPickerViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QISearchPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _tableView = [self newSearchTable];
    }
    return self;
}

-(void)loadView{
  [self setView:[[QISearchPickerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
  [self.searchView.searchBar setDelegate:self];
  [self.searchView.searchBar becomeFirstResponder];
  [self.searchView.exitButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  [self.searchView setTableView:self.tableView];
  [self.searchView addSubview:self.tableView]; 
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

- (void)dismiss{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Factory Methods

-(UITableView *)newSearchTable{
  UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor clearColor]];
  [tableView setBackgroundView:nil];
  [tableView setOpaque:NO];
  [tableView setSeparatorColor:[UIColor grayColor]];
  [tableView setShowsVerticalScrollIndicator:NO];
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  tableView.rowHeight = 40;
  tableView.dataSource = self;
  tableView.delegate = self;
  return tableView;
}

#pragma mark TableView Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 10; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *cellIdentifier = @"CustomCell";
  QISearchPickerTableViewCell *cell = (QISearchPickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QISearchPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  cell.textLabel.text = @"Search Result 1";
  return cell;  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSLog(@"Selected Search Result"); 
}

#pragma mark Search Bar Delegate Functions

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
  [self.searchView.searchBar resignFirstResponder];
}

@end
