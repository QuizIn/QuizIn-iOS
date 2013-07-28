#import <Foundation/Foundation.h>

@class QIQuizQuestion;
@class QIQuizQuestionViewController;


@interface QIQuizQuestionViewControllerFactory : NSObject

+ (QIQuizQuestionViewController *)questionViewControllerForQuestion:(QIQuizQuestion *)question;

@end
