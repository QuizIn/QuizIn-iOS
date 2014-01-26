#import "QIQuizFactory.h"

#import "QIConnectionsStore.h"
#import "QIQuiz.h"
#import "QIMultipleChoiceQuestion.h"
#import "QIBusinessCardQuestion.h"
#import "QIMatchingQuestion.h"
#import "QIPerson.h"
#import "QIPosition.h"
#import "QICompany.h"

#import "QIShuffleSet.h"

#import "LinkedIn.h"

@implementation QIQuizFactory

/*
 {
 code = "us:0";
 count = 204;
 name = "United States";
 },
 {
 code = "us:64";
 count = 176;
 name = "Austin, Texas Area";
 },
 {
 code = "in:0";
 count = 7;
 name = India;
 },
 {
 code = "in:6508";
 count = 6;
 name = "Hyderabad Area, India";
 },
 {
 code = "us:84";
 count = 5;
 name = "San Francisco Bay Area";
 },
 {
 code = "us:724";
 count = 4;
 name = "San Antonio, Texas Area";
 },
 {
 code = "hu:0";
 count = 3;
 name = Hungary;
 },
 {
 code = "mx:0";
 count = 2;
 name = Mexico;
 },
 {
 code = "us:31";
 count = 2;
 name = "Dallas/Fort Worth Area";
 },
 {
 code = "us:70";
 count = 2;
 name = "Greater New York City Area";
 }*/


//facets:(code,buckets:(code,name,count)) //  // current-company //@"facets": @"location",

+ (void)newFirstDegreeQuizForIndustries:(NSArray *)industryCodes
                  withCompletionBlock:(void (^)(QIQuiz *, NSError*))completionBlock {
  [LinkedIn allFirstDegreeConnectionsForAuthenticatedUserInIndustries:[industryCodes copy] onCompletion:^(QIConnectionsStore *connectionsStore, NSError *error) {
    QIQuiz *quiz = [self quizWithConnections:connectionsStore];
    if (quiz) {
      completionBlock? completionBlock(quiz, nil) :  NULL;
    } else {
      DDLogError(@"Could not create quiz for industry: ");
      // TODO(Rene): Setup errors to use one domain and define error codes.
      NSError *error = [NSError errorWithDomain:@"com.quizin.errors" code:-3 userInfo:nil];
      completionBlock ? completionBlock(nil, error) : NULL;
    }
  }];
}

+ (void)newFirstDegreeQuizForCurrentCompanies:(NSArray *)companyCodes
                          withCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock {
  [LinkedIn
   allFirstDegreeConnectionsForAuthenticatedUserInCurrentCompanies:[companyCodes copy]
   onCompletion:^(QIConnectionsStore *connectionsStore, NSError *error) {
    QIQuiz *quiz = [self quizWithConnections:connectionsStore];
    if (quiz) {
      completionBlock? completionBlock(quiz, nil) :  NULL;
    } else {
      DDLogError(@"Could not create quiz for current-company: ");
      // TODO(Rene): Setup errors to use one domain and define error codes.
      NSError *error = [NSError errorWithDomain:@"com.quizin.errors" code:-3 userInfo:nil];
      completionBlock ? completionBlock(nil, error) : NULL;
    }
  }];
}

+ (void)newFirstDegreeQuizForSchools:(NSArray *)schoolCodes
                 withCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock {
  [LinkedIn
   allFirstDegreeConnectionsForAuthenticatedUserInSchools:[schoolCodes copy]
   onCompletion:^(QIConnectionsStore *connectionsStore, NSError *error) {
     QIQuiz *quiz = [self quizWithConnections:connectionsStore];
     if (quiz) {
       completionBlock? completionBlock(quiz, nil) :  NULL;
     } else {
       DDLogError(@"Could not create quiz for industry: ");
       // TODO(Rene): Setup errors to use one domain and define error codes.
       NSError *error = [NSError errorWithDomain:@"com.quizin.errors" code:-3 userInfo:nil];
       completionBlock ? completionBlock(nil, error) : NULL;
     }
   }];
}

+ (void)newFirstDegreeQuizForLocations:(NSArray *)locationCodes
                   withCompletionBlock:(void (^)(QIQuiz *quiz, NSError *error))completionBlock {
  [LinkedIn
   allFirstDegreeConnectionsForAuthenticatedUserInLocations:[locationCodes copy]
   onCompletion:^(QIConnectionsStore *connectionsStore, NSError *error) {
     QIQuiz *quiz = [self quizWithConnections:connectionsStore];
     if (quiz) {
       completionBlock? completionBlock(quiz, nil) :  NULL;
     } else {
       DDLogError(@"Could not create quiz for industry: ");
       // TODO(Rene): Setup errors to use one domain and define error codes.
       NSError *error = [NSError errorWithDomain:@"com.quizin.errors" code:-3 userInfo:nil];
       completionBlock ? completionBlock(nil, error) : NULL;
     }
   }];
}

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
  NSAssert([connections.people count] >= 10, @"Must have at least 10 people to make Quiz");
  // TODO(Rene): Remove this requirement, simply include less multiple choice what's my name questions.
  NSAssert([connections.personIDsWithProfilePics count] >= 10,
           @"Must have at least 10 people with profile pics to make Quiz");
  
  NSMutableArray *questions = [NSMutableArray arrayWithCapacity:10];
  NSMutableSet *connectionsInQuiz = [NSMutableSet setWithCapacity:10];
  // TODO(Rene): Do we need a minimum of connections with profile pics?
  NSArray *connectionsWithProfilePic = [connections.personIDsWithProfilePics allObjects];
  
  // Pick a random connection.
  for (NSInteger i = 0; i < 10; i++) {
    NSString *personID = [self randomPersonIDfromConnections:connectionsWithProfilePic
                                           connectionsInQuiz:connectionsInQuiz];
    
    if (i < 2) {
      [questions addObject:[QIMatchingQuestion matchingQuestionForPersonID:personID
                                                          connectionsStore:connections]];
    } else if (i < 8) {
      // Build business card question.
      [questions addObject:[QIBusinessCardQuestion businessCardQuestionForPersonID:personID
                                                                  connectionsStore:connections]];
    } else {
      // Build a question.
      [questions addObject:[QIMultipleChoiceQuestion multipleChoiceQuestionForPersonID:personID
                                                                      connectionsStore:connections]];
    }
  }
  return [QIQuiz quizWithQuestions:questions];
}

+ (NSString *)randomPersonIDfromConnections:(NSArray *)connections
                          connectionsInQuiz:(NSMutableSet *)connectionsInQuiz {
  NSInteger randomConnectionIndex = 0;
  NSString *personID = nil;
  NSInteger tries = 0;
  do {
    tries++;
    randomConnectionIndex = arc4random_uniform([connections count]);
    personID = connections[randomConnectionIndex];
    if (tries > 10) {
      DDLogError(@"Couldn't find %d random connections.", 10);
      // TODO(Rene): Handle this better.
      return nil;
    }
  } while ([connectionsInQuiz containsObject:personID] == YES);
  [connectionsInQuiz addObject:personID];
  return personID;
}

@end
