
#import <UIKit/UIKit.h>
#import "QIStorePreviewViewController.h"
#import "QIStoreViewController.h"

@interface QIStoreView : UIView 

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) UILabel *storeStatusLabel;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) QIStoreTableHeaderView *headerView;
@property (nonatomic, strong) QIStoreTableFooterView *footerView;
@property (nonatomic, strong) UIView *spinningOverlay;

@end
