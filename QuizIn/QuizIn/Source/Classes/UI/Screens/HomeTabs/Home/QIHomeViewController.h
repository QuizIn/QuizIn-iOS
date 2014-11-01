#import <UIKit/UIKit.h>
#import "QIApplicationViewController.h"
@interface QIHomeViewController : UIViewController

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) UITabBarController *parentTabBarController;
@property (nonatomic, strong) QIApplicationViewController *applicationViewController; 

@end
