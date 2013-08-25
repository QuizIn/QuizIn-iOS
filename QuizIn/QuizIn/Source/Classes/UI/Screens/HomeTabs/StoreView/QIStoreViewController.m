
#import "QIStoreViewController.h"
#import "QIStoreTableHeaderView.h"
#import "QIStorePreviewViewController.h"
#import "QIStoreData.h"

@interface QIStoreViewController ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) QIStoreTableHeaderView *headerView;
@property (nonatomic, strong) NSArray *storeData;

@end

@implementation QIStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _headerView = [self newHeaderView];
      _tableView = [self newStoreTable];
      _storeData = [QIStoreData getStoreData];
    }
    return self;
}
-(void)loadView{
  self.view = [[QIStoreView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.title = @"Store";
  
  self.storeView.tableView = self.tableView;
  [self.storeView addSubview:self.tableView];
  
  QIStoreTableHeaderView *tableHeader = (QIStoreTableHeaderView *)self.storeView.tableView.tableHeaderView; 
  [tableHeader.buyAllButton addTarget:self action:@selector(buyAll) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark Actions

- (void)buyAll{
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
  [self presentViewController:previewController  animated:YES completion:nil];
}

- (void)preview:(UIButton *)button{
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
  [self presentViewController:previewController  animated:YES completion:nil];
}

- (void)buy:(UIButton *)button{
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
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

#pragma mark TableView

-(UITableView *)newStoreTable{
  UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor clearColor]];
  [tableView setBackgroundView:nil];
  [tableView setOpaque:NO];
  [tableView setSeparatorColor:[UIColor clearColor]];
  [tableView setShowsVerticalScrollIndicator:NO];
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  tableView.rowHeight = 107;
  tableView.sectionHeaderHeight = 25;
  tableView.tableHeaderView = self.headerView;
  tableView.dataSource = self;
  tableView.delegate = self;
  return tableView;
}

-(QIStoreTableHeaderView *)newHeaderView{
  QIStoreTableHeaderView *headerView = [[QIStoreTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 165)];
  headerView.backgroundColor = [UIColor clearColor];
  return headerView;
}


#pragma mark tableView Delegate Functions
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [self.storeData count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  QIStoreSectionHeaderView *headerView = [[QIStoreSectionHeaderView alloc] init];
  headerView.sectionTitle = [[self.storeData objectAtIndex:section] objectForKey:@"type"];
  return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[[self.storeData objectAtIndex:section] objectForKey:@"item"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  static NSString *cellIdentifier = @"CustomCell";
  QIStoreCellView *cell = (QIStoreCellView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QIStoreCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundView:nil];
    [cell setBackgroundColor:[UIColor clearColor]];
  }
  [cell.previewButton setTag:indexPath.row*2];
  [cell.buyButton setTag:indexPath.row*2+1];
  [cell.previewButton addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
  [cell.buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
  [cell setTitle:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemTitle"]];
  [cell setPrice:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemPrice"]];
  [cell setDescription:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemDescription"]];
  return cell;
}

@end
