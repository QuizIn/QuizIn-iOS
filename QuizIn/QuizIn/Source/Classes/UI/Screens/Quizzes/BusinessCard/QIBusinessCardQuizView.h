#import <UIKit/UIKit.h>
#import "QIProgressView.h"
#import "BusinessCardAnswer/QIBusinessCardAnswerView.h"

@interface QIBusinessCardQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, strong) NSArray *answerFirstNames;
@property(nonatomic, strong) NSArray *answerLastNames;
@property(nonatomic, strong) NSArray *answerCompanies;
@property(nonatomic, strong) NSArray *answerTitles;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, strong,readonly) UIButton *nextQuestionButton;

@end
