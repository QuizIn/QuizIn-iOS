
#import "QIStoreViewController.h"
#import "QIStoreTableHeaderView.h"
#import "QIStorePreviewViewController.h"
#import "QIStoreData.h"

#define SECTION_INDEX_SPAN 100.0f

@interface QIStoreViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QIStoreView *storeView; 
@property (nonatomic, strong) NSArray *storeData;
@property (nonatomic, strong) NSArray *products;

@end

@implementation QIStoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _storeData = nil;
    _products = nil;

    [self reloadView];
  }
  return self;
}

-(void)loadView{
  self.view = [[QIStoreView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.title = @"Store";
  
  self.storeView.tableView.dataSource = self;
  self.storeView.tableView.delegate = self;
  
  [self.storeView.headerView.buyAllButton addTarget:self action:@selector(buyAll) forControlEvents:UIControlEventTouchUpInside];
  [self.storeView.refreshButton addTarget:self action:@selector(reloadView) forControlEvents:UIControlEventTouchUpInside];
  [self.storeView.footerView.restoreButton addTarget:self action:@selector(restore) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
  [self reloadView];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)setParentTabBarController:(UITabBarController *)parentTabBarController{
  _parentTabBarController = parentTabBarController;
}


#pragma mark Actions

- (void)buyAll{
  NSLog(@"Buy All");
  SKProduct *product = [[QIStoreData getBuyAllProductWithProducts:self.products] objectAtIndex:0];
  [self.storeView.spinningOverlay setHidden:NO];
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
  [self.storeView.spinningOverlay setHidden:NO];
  [[QIIAPHelper sharedInstance] buyProduct:product]; 
}

- (void)restore{
  [self.storeView.spinningOverlay setHidden:NO];
  [[QIIAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)productPurchased:(NSNotification *)notification {
  [self reloadView];
}

- (void)productFailed:(NSNotification *)notification {
  NSString *errorMessage = [notification.userInfo objectForKey:@"errorMessage"];
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchasing Error" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [self reloadView];
}

- (void)reloadView{
    
  [[QIIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (success) {
        _products = products;
        _storeData = [QIStoreData getStoreDataWithProducts:_products];
        
        NSDictionary *item = [QIStoreData storeItemWithProduct:[[QIStoreData getBuyAllProductWithProducts:products] objectAtIndex:0]];
        [self.storeView.headerView.buyAllButton setHidden:NO];
        [self.storeView.headerView.bestOfferLabel setHidden:NO];
        [self.storeView.headerView.buyAllPriceLabel setHidden:NO];
        [self.storeView.tableView setHidden:NO];
        [self.storeView.headerView setAllPurchased:[[item objectForKey:@"itemPurchased"] boolValue]];
        [self.storeView.headerView setAllPrice:[item objectForKey:@"itemPrice"]];
        
        [self.storeView.storeStatusLabel setHidden:YES];
        [self.storeView.refreshButton setHidden:YES];
        [self.storeView.activity stopAnimating];
      }
      else {
         _storeData = nil;
        [self.storeView.storeStatusLabel setText:@"Cannot Load Store"];
        [self.storeView.storeStatusLabel setHidden:NO];
        [self.storeView.refreshButton setHidden:NO];
        [self.storeView.activity stopAnimating];
        [self.storeView.headerView.buyAllButton setHidden:YES];
        [self.storeView.headerView.bestOfferLabel setHidden:YES];
        [self.storeView.headerView.buyAllPriceLabel setHidden:YES];
        [self.storeView.tableView setHidden:YES];
      }
      [self.storeView.spinningOverlay setHidden:YES];
      _highlightedCell = 99;
      [self.storeView.tableView reloadData];
    });
  }];
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
