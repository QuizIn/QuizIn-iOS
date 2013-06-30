#import "QIQuizBuilder.h"

#import "QIConnections.h"
#import "QIQuiz.h"
#import "QIMultipleChoiceQuestion.h"
#import "QIPerson.h"

#import "LinkedIn.h"

@implementation QIQuizBuilder

+ (QIQuiz *)quizFromRandomConnections {
  
  __block NSInteger numConnections = 0;
  __block BOOL done = NO;
  [LinkedIn getPeopleCurrentUserConnectionsCountWithOnSuccess:^(NSInteger numberOfConnections) {
    numConnections = numberOfConnections;
    done = YES;
  } onFailure:^(NSError *error) {
    NSLog(@"Error: %@", error);
    done = YES;
  }];
  
  while (!done) {
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
  }
  done = NO;
  
  __block NSMutableArray *peopleForQuiz = [NSMutableArray arrayWithCapacity:10];
  
  for (NSInteger i = 0; i < 10; i++) {
    NSInteger randomPersonIndex = arc4random_uniform(numConnections);
    [LinkedIn getPeopleConnectionsWithStartIndex:randomPersonIndex count:1 onSuccess:^(QIConnections *connections) {
      [peopleForQuiz addObject:connections.people[0]];
      done = YES;
    } onFailure:^(NSError *error) {
      NSLog(@"Error: %@", error);
      done = YES;
    }];
    while (!done) {
      [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    done = NO;
  }
  
  QIConnections *connectionsForQuiz = [QIConnections new];
  connectionsForQuiz.people = [peopleForQuiz copy];
  return [self quizWithConnections:connectionsForQuiz];
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
