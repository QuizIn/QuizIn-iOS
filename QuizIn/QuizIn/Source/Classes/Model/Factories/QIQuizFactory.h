#import <Foundation/Foundation.h>

@class QIConnectionsStore;
@class QIQuiz;

@interface QIQuizFactory : NSObject

+ (void)quizFromRandomConnectionsWithCompletionBlock:(void (^)(QIQuiz *, NSError *))completionBlock;
+ (void)newFirstDegreeQuizForIndustry:(NSString *)industryCode
                  withCompletionBlock:(void (^)(QIQuiz *quiz, NSError*error))completionBlock;
+ (void)newFirstDegreeQuizForCurrentCompanies:(NSArray *)companyCodes
                          withCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock;
+ (void)newFirstDegreeQuizForSchools:(NSArray *)schoolCodes
                 withCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock;
+ (void)newFirstDegreeQuizForLocations:(NSArray *)locationCodes
                   withCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock;
+ (QIQuiz *)quizWithConnections:(QIConnectionsStore *)connections;

@end
