
#import <Foundation/Foundation.h>

@interface QIStatsTracker : NSObject

typedef enum QuizType : NSInteger QuizType;

enum QuizType : NSInteger {
  MultipleChoice,
  BusinessCard,
  Matching
};

+ (void)updateStatsWithID:(NSString *)ID quizType:(QuizType *)quizType correct:(BOOL)correct;

@end
