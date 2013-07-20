#import <UIKit/UIKit.h>
#import "QIProgressView.h"
#import "QICheckAnswersView.h"

@interface QIMultipleChoiceQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, strong) QICheckAnswersView *checkAnswersView;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, assign) NSUInteger currentAnswer;
@property(nonatomic, copy) NSString *question;
@property(nonatomic, strong) NSURL *profileImageURL;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, assign) NSUInteger correctAnswerIndex;
@end
