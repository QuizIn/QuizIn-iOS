#import "QIQuizQuestionViewController.h"
#import "QIMatchingQuizView.h"

@interface QIMatchingQuizViewController : QIQuizQuestionViewController <UIAlertViewDelegate,UIActionSheetDelegate>

@property(nonatomic, strong, readonly) QIMatchingQuizView *matchingQuizView;

@end
