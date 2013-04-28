#import <UIKit/UIKit.h>

@interface QIDrawerView : UIView

@property(nonatomic, strong, readonly) UINavigationBar *navigationBar;

- (void)displayContentView:(UIView *)contentView;
- (void)removeContentView;

@end
