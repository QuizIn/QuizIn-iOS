#import <UIKit/UIKit.h>
#import "QISettingsView.h"

@interface QISettingsViewController : UIViewController

@property (nonatomic, strong) QISettingsView *settingsView; 
@property (nonatomic, strong) UITabBarController *parentTabBarController;

@end
