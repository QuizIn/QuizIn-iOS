#import "QIQuizBuilder.h"

#import "QIConnections.h"
#import "QIQuiz.h"
#import "QIMultipleChoiceQuestion.h"
#import "QIPerson.h"

#import "LinkedIn.h"

@implementation QIQuizBuilder

+ (void)quizFromRandomConnectionsWithCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock {
  [LinkedIn getPeopleCurrentUserConnectionsCountWithOnSuccess:^(NSInteger numberOfConnections) {
    [self fetchRandomConnectionsFromNumberOfConnections:numberOfConnections completionBlock:^(QIConnections *connections, NSError *error) {
      if (completionBlock) {
        QIQuiz *quiz = [self quizWithConnections:connections];
        completionBlock(quiz, nil);
      }
    }];
  } onFailure:^(NSError *error) {
    NSLog(@"Error: %@", error);
    if (completionBlock) {
      completionBlock(nil, error);
    }
  }];
}

+ (void)fetchRandomConnectionsFromNumberOfConnections:(NSInteger)numberOfConnections
                                      completionBlock:(void (^)(QIConnections *connections, NSError *error))completionBlock {
  __block NSMutableArray *peopleForQuiz = [NSMutableArray arrayWithCapacity:40];
  __block NSInteger count = 0;
  __block BOOL anyFailures = NO;
  __block NSError *fetchError = nil;
  
  for (NSInteger i = 0; i < 40; i++) {
    NSInteger randomPersonIndex = arc4random_uniform(numberOfConnections);
    [LinkedIn getPeopleConnectionsWithStartIndex:randomPersonIndex count:1 onSuccess:^(QIConnections *connections) {
      count++;
      [peopleForQuiz addObject:connections.people[0]];
      if (count == 40) {
        if (completionBlock) {
          if (anyFailures) {
            completionBlock(nil, fetchError);
          } else {
            QIConnections *connectionsForQuiz = [QIConnections new];
            connectionsForQuiz.people = [peopleForQuiz copy];
            completionBlock(connectionsForQuiz, nil);
          }
        }
      }
    } onFailure:^(NSError *error) {
      count++;
      anyFailures = YES;
      NSLog(@"Error: %@", error);
      fetchError = error;
    }];
  }
}

+ (QIQuiz *)quizWithConnections:(QIConnections *)connections {
  NSAssert([connections.people count] >= 40, @"Must have at least 40 people to make Quiz");
  
  NSMutableArray *questions = [NSMutableArray arrayWithCapacity:10];
  for (NSInteger i = 0; i <= 36; ++i) {
    QIMultipleChoiceQuestion *question = [QIMultipleChoiceQuestion new];
    NSInteger correctPersonIndex = arc4random_uniform(4);
    question.person = connections.people[correctPersonIndex + i];
    question.questionPrompt = @"What is my name?";
    question.answers = @[[self nameFromConnections:connections atIndex:i],
                         [self nameFromConnections:connections atIndex:++i],
                         [self nameFromConnections:connections atIndex:++i],
                         [self nameFromConnections:connections atIndex:++i]];
    question.correctAnswerIndex = correctPersonIndex;
    NSLog(@"INDEX: %d", i);
    [questions addObject:question];
  }
  
  QIQuiz *quiz = [QIQuiz quizWithQuestions:[questions copy]];
  return quiz;
}

+ (NSString *)nameFromConnections:(QIConnections *)connections atIndex:(NSInteger)index {
  NSAssert(index < [connections.people count], @"Out of bounds index for fetched connections.");
  QIPerson *person = (QIPerson *)connections.people[index];
  return [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName];
}

@end
