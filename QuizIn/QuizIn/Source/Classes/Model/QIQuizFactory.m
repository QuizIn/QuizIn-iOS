#import "QIQuizFactory.h"

#import "QIConnectionsStore.h"
#import "QIQuiz.h"
#import "QIMultipleChoiceQuestion.h"
#import "QIPerson.h"

#import "QIShuffleSet.h"

#import "LinkedIn.h"

@implementation QIQuizFactory

+ (void)quizFromRandomConnectionsWithCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock {
  [LinkedIn randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:40 onCompletion:^(QIConnectionsStore *connectionsStore, NSError *error) {
    QIQuiz *quiz = [self quizWithConnections:connectionsStore];
    if (quiz) {
      completionBlock ? completionBlock(quiz, nil) : NULL;
    } else {
      DDLogError(@"Could not create quiz from random connections.");
      // TODO(Rene): Setup errors to use one domain and define error codes.
      NSError *error = [NSError errorWithDomain:@"com.quizin.errors" code:-3 userInfo:nil];
      completionBlock ? completionBlock(nil, error) : NULL;
    }
  }];
}

+ (QIQuiz *)quizWithConnections:(QIConnectionsStore *)connections {
  NSAssert([connections.people count] >= 20, @"Must have at least 40 people to make Quiz");
  // TODO(Rene): Remove this requirement, simply include less multiple choice what's my name questions.
  NSAssert([connections.personIDsWithProfilePics count] >= 10,
           @"Must have at least 10 people with profile pics to make Quiz");
  
  NSMutableArray *questions = [NSMutableArray arrayWithCapacity:10];
  NSMutableSet *connectionsInQuiz = [NSMutableSet setWithCapacity:10];
  NSArray *connectionsWithProfilePic = [connections.personIDsWithProfilePics allObjects];
  
  // Pick a random connection.
  for (NSInteger i = 0; i < 10; i++) {
    NSInteger randomConnectionIndex = 0;
    NSString *personID = nil;
    NSInteger tries = 0;
    // TODO(Rene): Create random generator and move this logic out to there.
    do {
      tries++;
      randomConnectionIndex = arc4random_uniform([connectionsWithProfilePic count]);
      personID = connectionsWithProfilePic[randomConnectionIndex];
      if (tries > 10) {
        DDLogError(@"Couldn't find %d random connections.", 10);
        return nil;
      }
    } while ([connectionsInQuiz containsObject:personID] == YES);
    [connectionsInQuiz addObject:personID];
    
    // Build a question.
    QIMultipleChoiceQuestion *question = [QIMultipleChoiceQuestion new];
    question.person = connections.people[personID];
    question.questionPrompt = @"What is my name?";
    
    // Find multiple choice answers.
    QIShuffleSet *multipleChoiceAnswers = [QIShuffleSet new];
    [multipleChoiceAnswers shuffleAddObject:[question.person.formattedName copy]];
    NSArray *namesPool = [connections.personNames allObjects];
    for (NSInteger i = 0; i < 3; i++) {
      NSString *answer = nil;
      NSInteger tries = 0;
      do {
        tries++;
        NSInteger randomIndex = arc4random_uniform([namesPool count]);
        answer = namesPool[randomIndex];
        if (tries > 10) {
          DDLogError(@"Couldn't find %d random answers.", 3);
          return nil;
        }
      } while ([multipleChoiceAnswers.orderedSet containsObject:answer] == YES);
      [multipleChoiceAnswers shuffleAddObject:answer];
    }
    question.answers = [multipleChoiceAnswers shuffledArray];
    question.correctAnswerIndex = [question.answers indexOfObject:question.person.formattedName];
    [questions addObject:question];
  }
  return [QIQuiz quizWithQuestions:questions];
}

@end
