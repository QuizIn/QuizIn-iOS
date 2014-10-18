
#import <UIKit/UIKit.h>

@interface QIGroupSelectionCellView : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) NSString *selectionTitle;
@property (nonatomic, strong) NSURL *logoURL;
@property (nonatomic, assign) NSInteger slideOffset;

@end
