
#import <UIKit/UIKit.h>

@interface QIProgressView : UIView

@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, strong, readonly) UIButton *exitButton;

@end
