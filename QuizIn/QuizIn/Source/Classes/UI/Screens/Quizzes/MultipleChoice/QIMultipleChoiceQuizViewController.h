#import <UIKit/UIKit.h>
#import "QIMultipleChoiceQuizView.h"

@class QIMultipleChoiceQuestion;

@interface QIMultipleChoiceQuizViewController : UIViewController <UIActionSheetDelegate>

@property(nonatomic, strong, readonly) QIMultipleChoiceQuizView *multipleChoiceView;

- (instancetype)initWithQuestion:(QIMultipleChoiceQuestion *)question;

@end
