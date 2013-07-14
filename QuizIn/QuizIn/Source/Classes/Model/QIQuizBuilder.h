#import <Foundation/Foundation.h>

@class QIConnections;
@class QIQuiz;

@interface QIQuizBuilder : NSObject

+ (void)quizFromRandomConnectionsWithCompletionBlock:(void (^)(QIQuiz *, NSError *))completionBlock;
+ (QIQuiz *)quizWithConnections:(QIConnections *)connections;

@end
