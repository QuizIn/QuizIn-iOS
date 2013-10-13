
#import "QIStoreViewController.h"
#import "QIStoreTableHeaderView.h"
#import "QIStorePreviewViewController.h"
#import "QIStoreData.h"

#define SECTION_INDEX_SPAN 100.0f

@interface QIStoreViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QIStoreTableHeaderView *headerView;
@property (nonatomic, strong) QIStoreView *storeView; 
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
    _storeData = nil;
    _products = nil;

    [self reloadView];
  }
  return self;
}

-(void)loadView{
  self.view = [[QIStoreView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.title = @"Store";
  
  self.storeView.tableView = self.tableView;
  [self.storeView addSubview:self.tableView];
  
  [self.headerView.buyAllButton addTarget:self action:@selector(buyAll) forControlEvents:UIControlEventTouchUpInside];
  [self.storeView.refreshButton addTarget:self action:@selector(reloadView) forControlEvents:UIControlEventTouchUpInside]; 
}

- (void)viewWillAppear:(BOOL)animated{
  [self reloadView]; 
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
  [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:0];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.highlightedCell = 99; 
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
  SKProduct *product = [[QIStoreData getBuyAllProductWithProducts:self.products] objectAtIndex:0];
  [[QIIAPHelper sharedInstance] buyProduct:product];
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
  [self reloadView];
}

- (void)updateCellHighlight{
  if (self.highlightedCell !=99){
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.highlightedCell inSection:0];
    QIStoreCellView *cell = (QIStoreCellView *)[self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [cell highlight];
  }
}

- (void)reloadView{
    
  [[QIIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
    if (success) {
      _products = products;
      _storeData = [QIStoreData getStoreDataWithProducts:_products];
      
      NSDictionary *item = [QIStoreData storeItemWithProduct:[[QIStoreData getBuyAllProductWithProducts:products] objectAtIndex:0]];
      [self.headerView.buyAllButton setHidden:NO];
      [self.headerView.bestOfferLabel setHidden:NO];
      [self.headerView.buyAllPriceLabel setHidden:NO];
      [self.headerView setAllPurchased:[[item objectForKey:@"itemPurchased"] boolValue]];
      [self.headerView setAllPrice:[item objectForKey:@"itemPrice"]];
      
      [self.storeView.storeStatusLabel setHidden:YES];
      [self.storeView.activity stopAnimating];
      [self.tableView reloadData]; 
    }
    else {
      [self.storeView.storeStatusLabel setText:@"Cannot Load Store"];
      [self.storeView.refreshButton setHidden:NO]; 
      [self.storeView.activity stopAnimating];
    }
  }];
  _highlightedCell = 99;
  [self.tableView reloadData];
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
  QIStoreTableHeaderView *headerView = [[QIStoreTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
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

  QIStoreCellView *cell = [[QIStoreCellView alloc] init];
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  [cell setBackgroundView:nil];
  [cell setBackgroundColor:[UIColor clearColor]];
  [cell.previewButton setTag:indexPath.section*SECTION_INDEX_SPAN +indexPath.row];
  [cell.buyButton setTag:indexPath.section*SECTION_INDEX_SPAN+indexPath.row];
  [cell.previewButton addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
  [cell.buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
  [cell setTitle:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemTitle"]];
  [cell setPrice:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemPrice"]];
  [cell setDescription:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemShortDescription"]];
  [cell setIconImage:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemIcon"]];
  [cell setPurchased:[[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemPurchased"] boolValue]];
  if (indexPath.section == 0 && indexPath.row == self.highlightedCell){
    [cell highlight]; 
  }
  return cell;
}

@end
