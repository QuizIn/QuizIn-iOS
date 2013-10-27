#import <UIKit/UIKit.h>

@class QIQuiz;

@interface QIQuizViewController : UIViewController
@property(nonatomic, assign) BOOL businessCard;
@property(nonatomic, assign) BOOL matching;

- (instancetype)initWithQuiz:(QIQuiz *)quiz;

@end
