
#import "QIStoreViewController.h"
#import "QIStoreTableHeaderView.h"
#import "QIStorePreviewViewController.h"
#import "QIStoreData.h"

#define SECTION_INDEX_SPAN 100.0f

@interface QIStoreViewController ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) QIStoreTableHeaderView *headerView;
@property (nonatomic, strong) NSArray *storeData;
@property (nonatomic, strong) NSArray *products;

@end

@implementation QIStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _headerView = [self newHeaderView];
      _tableView = [self newStoreTable];
      
      //todo fix testing 
      _storeData = nil; 
      _products = nil;
      [self.tableView reloadData];
      [[QIIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
          _products = products;
          _storeData = [QIStoreData getStoreDataWithProducts:_products]; 
          [self.tableView reloadData];
        }
      }];

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

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (QIStoreView *)storeView {
  return (QIStoreView *)self.view;
}


#pragma mark Actions

- (void)buyAll{
  NSLog(@"Buy All");
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
  [self presentViewController:previewController  animated:YES completion:nil];
}

- (void)preview:(UIButton *)button{
  NSInteger section = floor(button.tag/SECTION_INDEX_SPAN);
  NSInteger row = fmodf(button.tag,SECTION_INDEX_SPAN); 
  NSLog(@"Preview: Tag-%d  Section-%d  Row-%d",button.tag, section, row);
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
  [self presentViewController:previewController  animated:YES completion:nil];
}

- (void)buy:(UIButton *)button{
  NSInteger section = floor(button.tag/SECTION_INDEX_SPAN);
  NSInteger row = fmodf(button.tag,SECTION_INDEX_SPAN);
  NSLog(@"Buy: Tag-%d  Section-%d  Row-%d",button.tag, section, row);
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
  [self presentViewController:previewController  animated:YES completion:nil];
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
  
  [cell.previewButton setTag:indexPath.section*SECTION_INDEX_SPAN +indexPath.row];
  [cell.buyButton setTag:indexPath.section*SECTION_INDEX_SPAN+indexPath.row];
  [cell.previewButton addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
  [cell.buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
  
  [cell setTitle:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemTitle"]];
  [cell setPrice:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemPrice"]];
  [cell setDescription:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemShortDescription"]];
  [cell setIconImage:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemIcon"]];
  return cell;
}

@end
