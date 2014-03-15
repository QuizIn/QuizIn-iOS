#import <UIKit/UIKit.h>
#import "QISettingsView.h"

@class QIApplicationViewController;

@interface QISettingsViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) QISettingsView *settingsView; 
@property (nonatomic, strong) UITabBarController *parentTabBarController;
@property (nonatomic, weak) QIApplicationViewController *applicationViewController;
@property (nonatomic, strong) NSString *userID;

@end
