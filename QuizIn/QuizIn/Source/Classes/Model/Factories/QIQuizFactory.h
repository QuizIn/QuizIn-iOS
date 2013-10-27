#import <Foundation/Foundation.h>

@class QIConnectionsStore;
@class QIQuiz;

@interface QIQuizFactory : NSObject

+ (void)quizFromRandomConnectionsWithCompletionBlock:(void (^)(QIQuiz *, NSError *))completionBlock;
+ (void)newFirstDegreeQuizForIndustry:(NSString *)industryCode
                  withCompletionBlock:(void (^)(QIQuiz *, NSError*))completionBlock;
+ (QIQuiz *)quizWithConnections:(QIConnectionsStore *)connections;

@end
