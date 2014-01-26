#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QIQuizQuestionType) {
  QIQuizQuestionTypeMultipleChoice,
  QIQuizQuestionTypeMatching,
  QIQuizQuestionTypeBusinessCard,
};

static NSInteger kQINumberOfQuizTypes = 2;

@interface QIQuizQuestion : NSObject

@end
