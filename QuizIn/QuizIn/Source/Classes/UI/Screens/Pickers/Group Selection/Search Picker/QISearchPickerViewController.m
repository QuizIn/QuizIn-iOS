#import "QISearchPickerViewController.h"

#import "QILayoutGuideProvider.h"

@interface QISearchPickerViewController ()<UITableViewDataSource, UITableViewDelegate, QILayoutGuideProvider>

@end

@implementation QISearchPickerViewController

-(void)loadView{
  self.view = [[QISearchPickerView alloc] initWithFrame:CGRectZero layoutGuideProvider:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.searchView.searchBar setDelegate:self];
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
