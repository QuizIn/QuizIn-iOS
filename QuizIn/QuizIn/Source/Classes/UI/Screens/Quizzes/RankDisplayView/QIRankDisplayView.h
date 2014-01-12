
#import <UIKit/UIKit.h>

@interface QIRankDisplayView : UIView

@property (nonatomic,assign) int rank;
@property (nonatomic, strong,readonly) UIButton *fbShareButton;
@property (nonatomic, strong,readonly) UIButton *twitterShareButton;
@property (nonatomic, strong,readonly) UIButton *linkedInShareButton;
@property (nonatomic, strong) UIButton *exitButton;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSURL *profileImageURL;
@property (nonatomic, strong) NSString *profileName; 

- (void) updateLockedStatusLabel;

@end

