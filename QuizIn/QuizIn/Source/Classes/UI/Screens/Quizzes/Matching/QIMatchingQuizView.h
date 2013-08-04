#import <UIKit/UIKit.h>
#import "QIProgressView.h"
#import "QICheckAnswersView.h"
#import "QIRankDisplayView.h"

@interface QIMatchingQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, strong) QICheckAnswersView *checkAnswersView;
@property(nonatomic, strong) QIRankDisplayView *rankDisplayView;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, strong, readonly) UIButton *nextQuestionButton;
@property(nonatomic, copy) NSArray *questionImageURLs;
@property(nonatomic, copy) NSArray *answers;
// Array is in order of answers, each item in the array is the index of the matching picture.
@property(nonatomic, copy) NSArray *correctAnswers;
@property(nonatomic, strong) NSString *loggedInUserID; 


@end
