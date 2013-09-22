
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
      _highlightedCell = 99; 
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

- (void)viewWillAppear:(BOOL)animated{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
  [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:0];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
  {
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
    {
      [[(QIStoreCellView *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]] highlightTimer] invalidate];
    }
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark Properties

- (QIStoreView *)storeView {
  return (QIStoreView *)self.view;
}

- (void)setHighlightedCell:(NSInteger)highlightedCell{
  _highlightedCell = highlightedCell;
  [self updateCellHighlight]; 
}

- (void)setParentTabBarController:(UITabBarController *)parentTabBarController{
  _parentTabBarController = parentTabBarController;
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
  SKProduct *product = [[[[self.storeData objectAtIndex:section] objectForKey:@"item"] objectAtIndex:row] objectForKey:@"product"];
  [[QIIAPHelper sharedInstance] buyProduct:product]; 
}

- (void)productPurchased:(NSNotification *)notification {
  self.storeData = [QIStoreData getStoreDataWithProducts:_products];
  [self.tableView reloadData];
}

- (void)updateCellHighlight{
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.highlightedCell inSection:0];
  QIStoreCellView *cell = (QIStoreCellView *)[self.tableView cellForRowAtIndexPath:indexPath];
  [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES]; 
  [cell highlight]; 
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
  [tableView setAllowsSelection:YES]; 
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
  [cell setPurchased:[[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemPurchased"] boolValue]];
  if (indexPath.section == 0 & indexPath.row == self.highlightedCell){
    [cell highlight]; 
  }
  return cell;
}


@end
