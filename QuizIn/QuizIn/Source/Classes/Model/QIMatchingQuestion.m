#import "QIMatchingQuestion.h"

#import "QIConnectionsStore.h"
#import "QIShuffleSet.h"
#import "QIPerson.h"

@implementation QIMatchingQuestion

+ (instancetype)matchingQuestionForPersonID:(NSString *)personID
                           connectionsStore:(QIConnectionsStore *)connections {
  QIMatchingQuestion *question = [QIMatchingQuestion new];
  NSMutableArray *matchingQuizPeople = [NSMutableArray arrayWithCapacity:4];
  // TODO(Rene): Handle if have less than 4 people with profile pic.
  NSAssert([connections.personIDsWithProfilePics count] >= 4,
           @"Must have at least 4 people with profile pics to make a matching question");
  
  QIShuffleSet *peopleWithPicsSuffle = [QIShuffleSet new];
  for (NSString *personID in connections.personIDsWithProfilePics) {
    [peopleWithPicsSuffle shuffleAddObject:personID];
  }
  
  for (NSInteger i = 0; i < 4; i++) {
    NSString *personID = [peopleWithPicsSuffle shuffleNextObject];
    QIPerson *person = connections.people[personID];
    [matchingQuizPeople addObject:person];
  }
  
  // Name question.
  QIShuffleSet *answersShuffle = [QIShuffleSet new];
  for (QIPerson *person in matchingQuizPeople) {
    [answersShuffle shuffleAddObject:person];
  }
  NSMutableArray *answers = [NSMutableArray arrayWithCapacity:4];
  NSMutableArray *correctAnswers = [NSMutableArray arrayWithCapacity:4];
  for (NSInteger i = 0; i < 4; i++) {
    QIPerson *person = [answersShuffle shuffleNextObject];
    [answers addObject:person.formattedName];
    correctAnswers[i] = @([matchingQuizPeople indexOfObject:person]);
  }
  
  question.people = matchingQuizPeople;
  question.answers = answers;
  question.correctAnswers = correctAnswers;
  return question;
}

@end
