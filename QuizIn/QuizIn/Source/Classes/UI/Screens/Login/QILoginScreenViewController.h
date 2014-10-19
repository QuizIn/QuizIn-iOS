
#import <UIKit/UIKit.h>
#import "QILoginScreenView.h"
#import "QIApplicationViewController.h"

@interface QILoginScreenViewController : UIViewController

@property (nonatomic, strong, readonly) QILoginScreenView *loginScreenView;
@property (nonatomic, weak) QIApplicationViewController *appViewController;

@end
