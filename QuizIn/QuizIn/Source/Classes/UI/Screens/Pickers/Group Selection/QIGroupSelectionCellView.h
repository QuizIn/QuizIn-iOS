
#import <UIKit/UIKit.h>

@interface QIGroupSelectionCellView : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic,strong) NSString *selectionTitle;
@property (nonatomic,strong) NSString *selectionSubtitle;
@property (nonatomic,strong) NSString *numberOfContacts;
@property (nonatomic,strong) NSArray *imageURLs;
@property (nonatomic,strong) NSURL *logoURL;
@property (nonatomic,assign) NSLayoutConstraint  *slideOffset;

@end
