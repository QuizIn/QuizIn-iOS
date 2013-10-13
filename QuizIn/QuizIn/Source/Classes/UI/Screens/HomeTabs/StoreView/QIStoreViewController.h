
#import "QIIAPHelper.h"
#import "QIStoreTableHeaderView.h"
#import "QIStoreSectionHeaderView.h"
#import "QIStoreCellView.h"
#import "QIStoreView.h"

#import <UIKit/UIKit.h>

@interface QIStoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITabBarController *parentTabBarController;
@property (nonatomic, assign) NSInteger highlightedCell; 

@end