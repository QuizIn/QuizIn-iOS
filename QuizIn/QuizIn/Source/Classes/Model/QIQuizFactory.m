#import "QIQuizFactory.h"

#import "QIConnectionsStore.h"
#import "QIQuiz.h"
#import "QIMultipleChoiceQuestion.h"
#import "QIBusinessCardQuestion.h"
#import "QIPerson.h"
#import "QIPosition.h"
#import "QICompany.h"

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
    
    
    if (i < 4) {
      // Build business card question.
      QIBusinessCardQuestion *question = [QIBusinessCardQuestion new];
      question.person = connections.people[personID];
      
      
      // Build Names
      QIShuffleSet *namesAnswers = [QIShuffleSet new];
      [namesAnswers shuffleAddObject:[question.person.formattedName copy]];
      NSArray *namesPool = [connections.personNames allObjects];
      for (NSInteger i = 0; i < 2; i++) {
        NSString *answer = nil;
        NSInteger tries = 0;
        do {
          tries++;
          NSInteger randomIndex = arc4random_uniform([namesPool count]);
          answer = namesPool[randomIndex];
          if (tries > 10) {
            DDLogError(@"Couldn't find %d random answers.", 2);
            return nil;
          }
        } while ([namesAnswers.orderedSet containsObject:answer] == YES);
        [namesAnswers shuffleAddObject:answer];
      }
      question.names = [namesAnswers shuffledArray];
      question.correctNameIndex = [question.names indexOfObject:question.person.formattedName];
      
      // Build Companies
      QIShuffleSet *companyAnswers = [QIShuffleSet new];
      NSString *company = @"None";
      for (QIPosition *position in question.person.positions) {
        if (position.isCurrent) {
          company = [position.company.name copy];
        }
      }
      [companyAnswers shuffleAddObject:company];
      NSArray *companyPool = [connections.companyNames allObjects];
      for (NSInteger i = 0; i < 2; i++) {
        NSString *answer = nil;
        NSInteger tries = 0;
        do {
          tries++;
          NSInteger randomIndex = arc4random_uniform([companyPool count]);
          answer = companyPool[randomIndex];
          if (tries > 10) {
            DDLogError(@"Couldn't find %d random answers.", 2);
            return nil;
          }
        } while ([companyAnswers.orderedSet containsObject:answer] == YES);
        [companyAnswers shuffleAddObject:answer];
      }
      question.companies = [companyAnswers shuffledArray];
      question.correctCompanyIndex = [question.companies indexOfObject:company];
      
      
      // Build Titles
      QIShuffleSet *titleAnswers = [QIShuffleSet new];
      NSString *title = @"None";
      for (QIPosition *position in question.person.positions) {
        if (position.isCurrent) {
          title = [position.title copy];
        }
      }
      [titleAnswers shuffleAddObject:title];
      NSArray *titlePool = [connections.titleNames allObjects];
      for (NSInteger i = 0; i < 2; i++) {
        NSString *answer = nil;
        NSInteger tries = 0;
        do {
          tries++;
          NSInteger randomIndex = arc4random_uniform([titlePool count]);
          answer = titlePool[randomIndex];
          if (tries > 10) {
            DDLogError(@"Couldn't find %d random answers.", 2);
            return nil;
          }
        } while ([titleAnswers.orderedSet containsObject:answer] == YES);
        [titleAnswers shuffleAddObject:answer];
      }
      question.titles = [titleAnswers shuffledArray];
      question.correctTitleIndex = [question.companies indexOfObject:title];
      
      [questions addObject:question];
      
      
    } else {
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
  }
  return [QIQuiz quizWithQuestions:questions];
}

@end
