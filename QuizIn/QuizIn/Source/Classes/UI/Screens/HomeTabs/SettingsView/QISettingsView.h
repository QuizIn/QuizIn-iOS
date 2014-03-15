
#import <UIKit/UIKit.h>

@interface QISettingsView : UIView

@property (nonatomic, strong, readonly) UIButton *logoutButton;
@property (nonatomic, strong, readonly) UIButton *clearStatsButton;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSString *title; 


@end
