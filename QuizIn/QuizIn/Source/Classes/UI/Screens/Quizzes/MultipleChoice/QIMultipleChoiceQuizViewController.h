#import "QIQuizQuestionViewController.h"

#import "QIMultipleChoiceQuizView.h"

@class QIMultipleChoiceQuestion;

@interface QIMultipleChoiceQuizViewController : QIQuizQuestionViewController <UIActionSheetDelegate>

@property(nonatomic, strong, readonly) QIMultipleChoiceQuizView *multipleChoiceView;

@end
