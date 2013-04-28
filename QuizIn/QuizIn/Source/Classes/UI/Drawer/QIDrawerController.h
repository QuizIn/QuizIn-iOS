#import <UIKit/UIKit.h>

@interface QIDrawerController : UIViewController
- (void)updateViewControllers:(NSArray *)viewControllers;
- (void)selectVisibleViewController:(UIViewController *)viewController;
@end
