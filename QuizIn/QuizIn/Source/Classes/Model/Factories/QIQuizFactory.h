#import <Foundation/Foundation.h>

#import "QIQuizQuestion.h"

@class QIConnectionsStore;
@class QIQuiz;

@interface QIQuizFactory : NSObject

// TODO: WARNING! Will make multiple API calls to Linked In each time this method is called.
//  Store the info comming back from Linked In to prevent hitting throttle limits.
+ (void)quizWithPersonIDs:(NSArray *)personIDs
            questionTypes:(QIQuizQuestionAllowedTypes)questionTypes
          completionBlock:(void (^)(QIQuiz *, NSError *))completionBlock;
+ (void)quizFromRandomConnectionsWithQuestionTypes:(QIQuizQuestionAllowedTypes)questionTypes
                                   completionBlock:(void (^)(QIQuiz *, NSError *))completionBlock;
+ (void)newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionAllowedTypes)questionTypes
                              forIndustries:(NSArray *)industryCodes
                            completionBlock:(void (^)(QIQuiz *quiz, NSError*error))completionBlock;
+ (void)newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionAllowedTypes)questionTypes
                        forCurrentCompanies:(NSArray *)companyCodes
                            completionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock;
+ (void)newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionAllowedTypes)questionTypes
                                 forSchools:(NSArray *)schoolCodes
                            completionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock;
+ (void)newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionAllowedTypes)questionTypes
                               forLocations:(NSArray *)locationCodes
                            completionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock;
+ (QIQuiz *)quizWithConnections:(QIConnectionsStore *)connections
                  questionTypes:(QIQuizQuestionAllowedTypes)questionTypes;

@end
