
#import <UIKit/UIKit.h>

@interface QIStoreCellView : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *buyButton;

@end
