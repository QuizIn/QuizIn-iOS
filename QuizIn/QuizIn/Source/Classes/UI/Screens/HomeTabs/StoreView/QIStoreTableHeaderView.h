#import <UIKit/UIKit.h>

@interface QIStoreTableHeaderView : UIView

@property (nonatomic, strong) UIButton *buyAllButton;
@property (nonatomic, strong) UILabel *bestOfferLabel;
@property (nonatomic, strong) UILabel *buyAllPriceLabel;
@property (nonatomic, strong) UIImageView *checkmark;
@property (nonatomic, assign) BOOL allPurchased;

@end
