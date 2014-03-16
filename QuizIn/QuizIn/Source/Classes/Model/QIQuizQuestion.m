#import "QIQuizQuestion.h"

#import "QIBusinessCardQuestion.h"
#import "QIMatchingQuestion.h"
#import "QIMultipleChoiceQuestion.h"

static NSInteger kQINumberOfQuizTypes = 3;

@implementation QIQuizQuestion

+ (instancetype)newRandomQuestionForPersonID:(NSString *)personID
                            connectionsStore:(QIConnectionsStore *)connections
                               questionTypes:(QIQuizQuestionType)types {
  QIQuizQuestion *question = nil;
  QIQuizQuestionType randomType = [self randomQuestionTypeOnlyUsingQuestionTypes:types];
  
  switch (randomType) {
    case QIQuizQuestionTypeBusinessCard:
      question = [QIBusinessCardQuestion businessCardQuestionForPersonID:personID
                                                        connectionsStore:connections];
      break;
      
    case QIQuizQuestionTypeMatching:
      question = [QIMatchingQuestion matchingQuestionForPersonID:personID
                                                connectionsStore:connections];
      break;
      
    case QIQuizQuestionTypeMultipleChoice:
      question = [QIMultipleChoiceQuestion multipleChoiceQuestionForPersonID:personID
                                                            connectionsStore:connections];
      break;
      
    case QIQuizQuestionTypeNone:
      question = nil;
      break;
  }
  return question;
}

+ (QIQuizQuestionType)randomQuestionTypeOnlyUsingQuestionTypes:(QIQuizQuestionType)types {
  BOOL containsType = NO;
  QIQuizQuestionType randomType = QIQuizQuestionTypeNone;
  NSInteger count = 0;
  do {
    if (count > 100) {
      NSAssert(NO, @"Something went wrong here.");
      break;
    }
    count++;
    randomType = arc4random_uniform(kQINumberOfQuizTypes) + 1;
    containsType = (types & randomType) != 0;
  } while (!containsType); // Bitmask check.
  return randomType;
}

@end
