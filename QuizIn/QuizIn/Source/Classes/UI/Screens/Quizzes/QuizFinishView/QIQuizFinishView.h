#import <UIKit/UIKit.h>

@interface QIQuizFinishView : UIView

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *goAgainButton;

@property (nonatomic, assign) NSInteger correctAnswers;
@property (nonatomic, assign) NSInteger totalQuestions;

@end
