
#import <UIKit/UIKit.h>

@interface QICheckAnswersView : UIView

@property(nonatomic, strong,readonly) UIButton *checkButton;
@property(nonatomic, strong,readonly) UIButton *helpButton;
@property(nonatomic, strong,readonly) UIButton *nextButton;
@property(nonatomic, strong,readonly) UIButton *againButton;
@property(nonatomic, strong,readonly) UIButton *resultHideButton;
@property(nonatomic, strong,readonly) UIButton *seeProfilesButton; 


-(void)correct:(BOOL)correct;
-(void)resetView; 

@end



