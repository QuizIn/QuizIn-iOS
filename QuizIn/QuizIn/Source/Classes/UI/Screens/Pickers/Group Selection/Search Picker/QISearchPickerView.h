#import <UIKit/UIKit.h>

@protocol QILayoutGuideProvider;

@interface QISearchPickerView : UIView

@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIButton *exitButton;

// Designated initializer.
- (id)initWithFrame:(CGRect)frame
    layoutGuideProvider:(id<QILayoutGuideProvider>)layoutGuideProvider;

@end
