
#import "QIStoreViewController.h"
#import "QIStoreTableHeaderView.h"
#import "QIStorePreviewViewController.h"
#import "QIStoreData.h"

//todo temp
#import "QILoginScreenViewController.h"

#define SECTION_INDEX_SPAN 100.0f

@interface QIStoreViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) QIStoreView *storeView; 
@property (nonatomic, strong) NSArray *storeData;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) BOOL allPurchased;

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
  [super viewWillAppear:NO];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productFailed:) name:IAPHelperProductFailedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:NO];
  [self reloadView];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:NO]; 
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
  SKProduct *product = [[QIStoreData getBuyAllProductWithProducts:self.products] objectAtIndex:0];
  [self.storeView.spinningOverlay setHidden:NO];
  [[QIIAPHelper sharedInstance] buyProduct:product];
}

- (void)preview:(UIButton *)button{
  QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
  previewController.previewView.previewTag = button.tag;
  [self presentViewController:previewController  animated:YES completion:nil];
}

- (void)buy:(UIButton *)button{
  SKProduct *product = [[[[self.storeData objectAtIndex:button.tag] objectForKey:@"item"] objectAtIndex:0] objectForKey:@"product"];
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
        QIIAPHelper *store = [QIIAPHelper sharedInstance];
        _allPurchased = [store productPurchased:@"com.kuhlmanation.hobnob.p_kit"];
        
        NSDictionary *item = [QIStoreData storeItemWithProduct:[[QIStoreData getBuyAllProductWithProducts:products] objectAtIndex:0]];
        [self.storeView.headerView.buyAllButton setHidden:NO];
        [self.storeView.headerView.bestOfferLabel setHidden:NO];
        [self.storeView.headerView.buyAllPriceLabel setHidden:NO];
        [self.storeView.tableView setHidden:NO];
        [self.storeView.headerView setAllPurchased:[[item objectForKey:@"itemPurchased"] boolValue]];
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
  [headerView setSectionTitle:[[self.storeData objectAtIndex:section] objectForKey:@"type"]];
  [headerView setPrice:[[[[self.storeData objectAtIndex:section] objectForKey:@"item"] objectAtIndex:0] objectForKey:@"itemPrice"]];
  [headerView setPurchased:[[[[[self.storeData objectAtIndex:section] objectForKey:@"item"] objectAtIndex:0] objectForKey:@"itemPurchased"] boolValue] || self.allPurchased];
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
  [cell.previewButton setTag:indexPath.section];
  [cell.iconImageView setTag:indexPath.section];
  [cell.buyButton setTag:indexPath.section];
  [cell.previewButton addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
  [cell.iconImageView addTarget:self action:@selector(preview:) forControlEvents:UIControlEventTouchUpInside];
  [cell.buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
  [cell setDescriptionString:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemShortDescription"]];
  [cell setIconImage:[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemIcon"]];
  [cell setPurchased:[[[[[self.storeData objectAtIndex:indexPath.section] objectForKey:@"item"] objectAtIndex:indexPath.row] objectForKey:@"itemPurchased"] boolValue] || self.allPurchased];
  return cell;
}

@end
