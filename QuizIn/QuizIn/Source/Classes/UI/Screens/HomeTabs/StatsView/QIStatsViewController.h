
#import <UIKit/UIKit.h>
#import "QIStatsView.h"
#import "QIStatsData.h"

@interface QIStatsViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) QIStatsView *statsView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) UITabBarController *parentTabBarController; 

@end
