#import <UIKit/UIKit.h>

@interface QIQuizFinishView : UIView

@property (nonatomic, strong) UIButton *continueButton;

@property (nonatomic, assign) NSInteger correctAnswers;
@property (nonatomic, assign) NSInteger totalQuestions;

@end
