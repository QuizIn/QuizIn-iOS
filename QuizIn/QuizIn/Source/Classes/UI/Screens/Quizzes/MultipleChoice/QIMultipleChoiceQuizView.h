#import <UIKit/UIKit.h>
#import "QIProgressView.h"
#import "QICheckAnswersView.h"
#import "QIRankDisplayView.h"
#import "QIPerson.h"

@interface QIMultipleChoiceQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, strong) QICheckAnswersView *checkAnswersView;
@property (nonatomic, strong) QIRankDisplayView *rankDisplayView;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;
@property(nonatomic, copy) NSString *question;
@property(nonatomic, strong) NSURL *profileImageURL;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, assign) NSUInteger correctAnswerIndex;
@property(nonatomic, strong) QIPerson *answerPerson;
@property(nonatomic, strong) NSString *loggedInUserID;

-(void)hideRankDisplay;

@end
