#import "QIBusinessCardQuestion.h"

#import "QIConnectionsStore.h"
#import "QIShuffleSet.h"
#import "QIPerson.h"
#import "QIPosition.h"
#import "QICompany.h"

@implementation QIBusinessCardQuestion

+ (instancetype)businessCardQuestionForPersonID:(NSString *)personID
                               connectionsStore:(QIConnectionsStore *)connections {
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
  question.correctTitleIndex = [question.titles indexOfObject:title];
  return question;
}

@end
