#import "QIMultipleChoiceQuestion.h"

#import "QIConnectionsStore.h"
#import "QIShuffleSet.h"
#import "QIPerson.h"

@implementation QIMultipleChoiceQuestion

+ (instancetype)multipleChoiceQuestionForPersonID:(NSString *)personID
                                 connectionsStore:(QIConnectionsStore *)connections {
  // Build a question.
  QIMultipleChoiceQuestion *question = [self new];
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
  return question;
}

@end
