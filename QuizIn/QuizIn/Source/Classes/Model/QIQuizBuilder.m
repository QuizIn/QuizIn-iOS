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
  __block NSMutableArray *peopleForQuiz = [NSMutableArray arrayWithCapacity:10];
  __block NSInteger count = 0;
  __block BOOL anyFailures = NO;
  __block NSError *fetchError = nil;
  
  for (NSInteger i = 0; i < 10; i++) {
    NSInteger randomPersonIndex = arc4random_uniform(numberOfConnections);
    [LinkedIn getPeopleConnectionsWithStartIndex:randomPersonIndex count:1 onSuccess:^(QIConnections *connections) {
      count++;
      [peopleForQuiz addObject:connections.people[0]];
      if (count == 10) {
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
  NSAssert([connections.people count] >= 10, @"Must have at least 10 people to make Quiz");
  
  NSMutableArray *questions = [NSMutableArray arrayWithCapacity:10];
  for (NSInteger i = 0; i < 10; i++) {
    QIPerson *person = connections.people[i];
    QIMultipleChoiceQuestion *question = [QIMultipleChoiceQuestion new];
    question.person = person;
    question.questionPrompt = @"What is my name?";
    question.answers = @[@"John",
                         [NSString stringWithFormat:@"%@ %@", person.firstName, person.lastName],
                         @"Bill",
                         @"Zach"];
    question.correctAnswerIndex = 1;
    
    [questions addObject:question];
  }
  
  QIQuiz *quiz = [QIQuiz quizWithQuestions:[questions copy]];
  return quiz;
}

@end
