#import "QIQuizQuestionViewController.h"
#import "QIBusinessCardQuizView.h"

@interface QIBusinessCardViewController : QIQuizQuestionViewController <UIAlertViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) QIBusinessCardQuizView *businessCardQuizView;

@end
