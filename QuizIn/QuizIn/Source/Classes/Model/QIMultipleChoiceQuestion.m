#import "QIMultipleChoiceQuestion.h"

#import "QIConnectionsStore.h"
#import "QIShuffleSet.h"
#import "QIPerson.h"
#import "QIPosition.h"
#import "QICompany.h"
#import "QILocation.h"

typedef NS_ENUM(NSInteger, QIMultipleChoiceQuestionType) {
  QIMultipleChoiceQuestionTypeName,
  QIMultipleChoiceQuestionTypeCompany,
  QIMultipleChoiceQuestionTypePosition,
  QIMultipleChoiceQuestionTypeIndustry,
  QIMultipleChoiceQuestionTypeLocation,
};

static NSInteger kQINumberOfMultipleChoiceQuestionTypes = 5;

@implementation QIMultipleChoiceQuestion

+ (instancetype)multipleChoiceQuestionForPersonID:(NSString *)personID
                                 connectionsStore:(QIConnectionsStore *)connections {

  QIMultipleChoiceQuestionType type = arc4random_uniform(kQINumberOfMultipleChoiceQuestionTypes);
  switch (type) {
    case QIMultipleChoiceQuestionTypeName:
      return [self multipleChoiceNameQuestionForPersonID:personID connectionsStore:connections];
      break;
      
    case QIMultipleChoiceQuestionTypeCompany: {
      QIPerson *person = connections.people[personID];
      if (!person.currentPosition || !person.currentPosition.company) {
        return [self multipleChoiceNameQuestionForPersonID:personID connectionsStore:connections];
      }
      return [self multipleChoiceCompanyQuestionForPersonID:personID connectionsStore:connections];
      break;
    }
      
    case QIMultipleChoiceQuestionTypeIndustry: {
      QIPerson *person = connections.people[personID];
      if (!person.industry) {
        return [self multipleChoiceNameQuestionForPersonID:personID connectionsStore:connections];
      }
      return [self multipleChoiceIndustryQuestionForPersonID:personID connectionsStore:connections];
      break;
    }
      
    case QIMultipleChoiceQuestionTypeLocation: {
      QIPerson *person = connections.people[personID];
      if (!person.location) {
        return [self multipleChoiceNameQuestionForPersonID:personID connectionsStore:connections];
      }
      return [self multipleChoiceLocationQuestionForPersonID:personID connectionsStore:connections];
      break;
    }
      
    case QIMultipleChoiceQuestionTypePosition: {
      QIPerson *person = connections.people[personID];
      if (!person.currentPosition || !person.currentPosition.title) {
        return [self multipleChoiceNameQuestionForPersonID:personID connectionsStore:connections];
      }
      return [self multipleChoicePositionQuestionForPersonID:personID connectionsStore:connections];
      break;
    }
  }
  
  return nil;
}

+ (instancetype)multipleChoiceNameQuestionForPersonID:(NSString *)personID
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
  // TODO(Rene): !!WATCH OUT for duplicate options!!
  question.correctAnswerIndex = [question.answers indexOfObject:question.person.formattedName];
  return question;
}

// TODO: Make sure person with personID has a current position before creating a question of this type.
+ (instancetype)multipleChoiceCompanyQuestionForPersonID:(NSString *)personID
                                     connectionsStore:(QIConnectionsStore *)connections {
  // Build a question.
  QIMultipleChoiceQuestion *question = [self new];
  question.person = connections.people[personID];
  question.questionPrompt = @"Where do I work?";
  
  // Find multiple choice answers.
  QIShuffleSet *multipleChoiceAnswers = [QIShuffleSet new];
  QIPosition *currentPosition = question.person.currentPosition;
  [multipleChoiceAnswers shuffleAddObject:[currentPosition.company.name copy]];
  NSArray *companyPool = [connections.companyNames allObjects];
  for (NSInteger i = 0; i < 3; i++) {
    NSString *answer = nil;
    NSInteger tries = 0;
    do {
      tries++;
      NSInteger randomIndex = arc4random_uniform([companyPool count]);
      answer = companyPool[randomIndex];
      if (tries > 10) {
        DDLogError(@"Couldn't find %d random answers.", 3);
        return nil;
      }
    } while ([multipleChoiceAnswers.orderedSet containsObject:answer] == YES);
    [multipleChoiceAnswers shuffleAddObject:answer];
  }
  question.answers = [multipleChoiceAnswers shuffledArray];
  // TODO(Rene): !!WATCH OUT for duplicate options!!
  question.correctAnswerIndex = [question.answers indexOfObject:currentPosition.company.name];
  return question;
}

+ (instancetype)multipleChoicePositionQuestionForPersonID:(NSString *)personID
                                         connectionsStore:(QIConnectionsStore *)connections {
  // Build a question.
  QIMultipleChoiceQuestion *question = [self new];
  question.person = connections.people[personID];
  question.questionPrompt = @"What is my title?";
  
  // Find multiple choice answers.
  QIShuffleSet *multipleChoiceAnswers = [QIShuffleSet new];
  QIPosition *currentPosition = question.person.currentPosition;
  [multipleChoiceAnswers shuffleAddObject:[currentPosition.title copy]];
  NSArray *titlePool = [connections.titleNames allObjects];
  for (NSInteger i = 0; i < 3; i++) {
    NSString *answer = nil;
    NSInteger tries = 0;
    do {
      tries++;
      NSInteger randomIndex = arc4random_uniform([titlePool count]);
      answer = titlePool[randomIndex];
      if (tries > 10) {
        DDLogError(@"Couldn't find %d random answers.", 3);
        return nil;
      }
    } while ([multipleChoiceAnswers.orderedSet containsObject:answer] == YES);
    [multipleChoiceAnswers shuffleAddObject:answer];
  }
  question.answers = [multipleChoiceAnswers shuffledArray];
  // TODO(Rene): !!WATCH OUT for duplicate options!!
  question.correctAnswerIndex = [question.answers indexOfObject:currentPosition.title];
  return question;
}

+ (instancetype)multipleChoiceIndustryQuestionForPersonID:(NSString *)personID
                                         connectionsStore:(QIConnectionsStore *)connections {
  // Build a question.
  QIMultipleChoiceQuestion *question = [self new];
  question.person = connections.people[personID];
  question.questionPrompt = @"Which industry do I work in?";
  
  // Find multiple choice answers.
  QIShuffleSet *multipleChoiceAnswers = [QIShuffleSet new];
  [multipleChoiceAnswers shuffleAddObject:[question.person.industry copy]];
  NSArray *industryPool = [connections.industries allObjects];
  for (NSInteger i = 0; i < 3; i++) {
    NSString *answer = nil;
    NSInteger tries = 0;
    do {
      tries++;
      NSInteger randomIndex = arc4random_uniform([industryPool count]);
      answer = industryPool[randomIndex];
      if (tries > 10) {
        DDLogError(@"Couldn't find %d random answers.", 3);
        return nil;
      }
    } while ([multipleChoiceAnswers.orderedSet containsObject:answer] == YES);
    [multipleChoiceAnswers shuffleAddObject:answer];
  }
  question.answers = [multipleChoiceAnswers shuffledArray];
  // TODO(Rene): !!WATCH OUT for duplicate options!!
  question.correctAnswerIndex = [question.answers indexOfObject:question.person.industry];
  return question;
}

+ (instancetype)multipleChoiceLocationQuestionForPersonID:(NSString *)personID
                                     connectionsStore:(QIConnectionsStore *)connections {
  // Build a question.
  QIMultipleChoiceQuestion *question = [self new];
  question.person = connections.people[personID];
  question.questionPrompt = @"Which location do I work in?";
  
  // Find multiple choice answers.
  QIShuffleSet *multipleChoiceAnswers = [QIShuffleSet new];
  [multipleChoiceAnswers shuffleAddObject:[question.person.location.name copy]];
  NSArray *cityPool = [connections.cityNames allObjects];
  for (NSInteger i = 0; i < 3; i++) {
    NSString *answer = nil;
    NSInteger tries = 0;
    do {
      tries++;
      NSInteger randomIndex = arc4random_uniform([cityPool count]);
      answer = cityPool[randomIndex];
      if (tries > 10) {
        DDLogError(@"Couldn't find %d random answers.", 3);
        return nil;
      }
    } while ([multipleChoiceAnswers.orderedSet containsObject:answer] == YES);
    [multipleChoiceAnswers shuffleAddObject:answer];
  }
  question.answers = [multipleChoiceAnswers shuffledArray];
  // TODO(Rene): !!WATCH OUT for duplicate options!!
  question.correctAnswerIndex = [question.answers indexOfObject:question.person.location.name];
  return question;
}

@end
