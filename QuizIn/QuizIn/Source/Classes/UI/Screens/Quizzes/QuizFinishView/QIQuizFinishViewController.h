#import <UIKit/UIKit.h>
#import "QIQuizFinishView.h"

@interface QIQuizFinishViewController : UIViewController

@property (nonatomic, strong, readonly) QIQuizFinishView *quizFinishView;
@property (nonatomic, assign) NSInteger correctAnswers;
@property (nonatomic, assign) NSInteger totalQuestions;

@end
