#import <UIKit/UIKit.h>

@interface QIMultipleChoiceQuizView : UIView
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, copy) NSString *question;
@property(nonatomic, strong) UIImage *profileImage;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, strong, readonly) UIButton *exitButton;
@end
