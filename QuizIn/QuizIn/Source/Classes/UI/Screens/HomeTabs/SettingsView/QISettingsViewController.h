#import <UIKit/UIKit.h>
#import "QISettingsView.h"

@class QIApplicationViewController;

@interface QISettingsViewController : UIViewController

@property (nonatomic, strong) QISettingsView *settingsView; 
@property (nonatomic, strong) UITabBarController *parentTabBarController;
@property (nonatomic, weak) QIApplicationViewController *applicationViewController;

@end
