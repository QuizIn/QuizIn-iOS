#import <Foundation/Foundation.h>

@class QIConnections;
@class QIQuiz;

@interface QIQuizBuilder : NSObject

+ (QIQuiz *)quizFromRandomConnections;
+ (QIQuiz *)quizWithConnections:(QIConnections *)connections;

@end
