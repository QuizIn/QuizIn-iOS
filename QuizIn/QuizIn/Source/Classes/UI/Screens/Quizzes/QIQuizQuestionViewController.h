#import <UIKit/UIKit.h>

#import "QIQuizQuestionViewInteractor.h"

@class QIQuizQuestion;
@class QICheckAnswersView;
@class QIRankDisplayView;
@class QIProgressView;

@interface QIQuizQuestionViewController : UIViewController <QIQuizQuestionViewInteractor>

@property(nonatomic, strong, readonly) QICheckAnswersView *checkAnswersView;
@property(nonatomic, strong, readonly) QIRankDisplayView *rankDisplayView;
@property(nonatomic, strong, readonly) QIProgressView *progressView;
@property(nonatomic, assign) BOOL isCorrect;

- (instancetype)initWithQuestion:(QIQuizQuestion *)question;

@end
