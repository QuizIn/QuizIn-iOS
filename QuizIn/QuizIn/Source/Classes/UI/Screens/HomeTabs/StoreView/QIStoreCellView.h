
#import <UIKit/UIKit.h>

@interface QIStoreCellView : UITableViewCell

@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *iconImageView; 
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, assign) BOOL purchased;
@property (nonatomic, strong) NSTimer *highlightTimer;
@property (nonatomic, strong) NSString *descriptionString; 

@end
