#import "QIQuizQuestion.h"

#import "QIBusinessCardQuestion.h"
#import "QIMatchingQuestion.h"
#import "QIMultipleChoiceQuestion.h"

typedef NS_ENUM(NSInteger, QIQuizQuestionType) {
  QIQuizQuestionTypeMultipleChoice,
  QIQuizQuestionTypeMatching,
  QIQuizQuestionTypeBusinessCard,
};

static NSInteger kQINumberOfQuizTypes = 3;

@implementation QIQuizQuestion

+ (instancetype)newRandomQuestionForPersonID:(NSString *)personID
                            connectionsStore:(QIConnectionsStore *)connections {
  QIQuizQuestion *question = nil;
  QIQuizQuestionType type = arc4random_uniform(kQINumberOfQuizTypes);
  switch (type) {
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
  }
  return question;
}

@end
