#import <UIKit/UIKit.h>
#import "QIProgressView.h"

@interface QIMultipleChoiceQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView; 
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, copy) NSString *question;
@property(nonatomic, strong) UIImage *profileImage;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, strong) UIButton *nextQuestionButton;
@end
