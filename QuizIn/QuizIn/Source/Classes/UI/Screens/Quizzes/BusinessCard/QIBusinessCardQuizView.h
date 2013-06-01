#import <UIKit/UIKit.h>
#import "QIProgressView.h"
#import "BusinessCardAnswer/QIBusinessCardAnswerView.h"

@interface QIBusinessCardQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, strong) QIBusinessCardAnswerView *answerName;
@property(nonatomic, strong) QIBusinessCardAnswerView *answerTitle;
@property(nonatomic, strong) QIBusinessCardAnswerView *answerCompany;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, strong,readonly) UIButton *nextQuestionButton;

@end
