#import <UIKit/UIKit.h>

@class QIQuizQuestion;
@class QICheckAnswersView;
@class QIRankDisplayView;
@class QIProgressView;

@interface QIQuizQuestionViewController : UIViewController

@property(nonatomic, strong, readonly) QICheckAnswersView *checkAnswersView;
@property(nonatomic, strong, readonly) QIRankDisplayView *rankDisplayView;
@property(nonatomic, strong, readonly) QIProgressView *progressView;

- (instancetype)initWithQuestion:(QIQuizQuestion *)question;

@end
