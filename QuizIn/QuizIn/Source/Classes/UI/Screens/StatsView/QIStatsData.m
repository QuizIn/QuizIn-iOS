
#import "QIStatsData.h"

@implementation QIStatsData

/*
 //Quizzes Started
 //Quizzes Complete
 //Completion percent
 //How well you know each person
 //Last score
 //Average Score
 
 //Dictionary Structure
// key: UserID    Dictionary
  // key:CurrentRank              Integer
  // key:TotalCorrectAnswers      Integer
  // key:TotalIncorrectAnswers    Integer
  // key:IndividualStats          Array
        //Array Elements            Dictionary
      //key:UserID              NSString
      //key:UserFirstName       NSString
      //key:UserLastName        NSString
      //key:CorrectAnswers      Integer
      //key:IncorrectAnswers    Integer
*/
 
+ (void)setUpStatsWithNewLoggedInUserID:(NSString *)ID{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  
  NSNumber *currentRank = [NSNumber numberWithInt:0];
  NSNumber *totalCorrectAnswers = [NSNumber numberWithInt:0];
  NSNumber *totalIncorrectAnswers = [NSNumber numberWithInt:0];
  NSMutableDictionary *individualConnectionStats = [NSMutableDictionary dictionary];
  
  //only for testing remove later
  NSString *userID = @"1234testID4321";
  NSString *userFirstName = @"Rick";
  NSString *userLastName = @"Kuhlman";
  NSNumber *correctAnswers = [NSNumber numberWithInt:12];
  NSNumber *incorrectAnswers = [NSNumber numberWithInt:10];
  
  [individualConnectionStats setObject:userID forKey:@"userID"];
  [individualConnectionStats setObject:userFirstName forKey:@"userFirstName"];
  [individualConnectionStats setObject:userLastName forKey:@"userLastName"];
  [individualConnectionStats setObject:correctAnswers forKey:@"correctAnswers"];
  [individualConnectionStats setObject:incorrectAnswers forKey:@"incorrectAnswers"];
  // end test data
  
  NSMutableArray *connectionStats = [NSMutableArray arrayWithObjects:individualConnectionStats,nil];
  
  NSMutableDictionary *userStats = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    currentRank,            @"currentRank",
                                    totalCorrectAnswers,    @"totalCorrectAnswers",
                                    totalIncorrectAnswers,  @"totalIncorrectAnswers",
                                    connectionStats,        @"connectionStats",
                                    nil];
  
  [prefs setObject:userStats forKey:ID];
  [prefs synchronize];
  return;
}

+(void)printStatsOfID:(NSString *)ID{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:ID] mutableCopy];
  int currentRank = [[stats objectForKey:@"currentRank"] integerValue];
  int totalCorrectAnswers = [[stats objectForKey:@"totalCorrectAnswers"] integerValue];
  int totalIncorrectAnswers = [[stats objectForKey:@"totalIncorrectAnswers"] integerValue];
  NSMutableArray *connectionStats = [[stats objectForKey:@"connectionStats"] mutableCopy];
  NSLog(@"Current Rank: %d \n CorrectAnswers: %d \n Incorrect Answers: %d \n",currentRank, totalCorrectAnswers, totalIncorrectAnswers);
  for (int i = 0; i<[connectionStats count]; i++){
    NSMutableDictionary *individualConnectionStats = [[connectionStats objectAtIndex:i] mutableCopy];
    NSString *userID = [individualConnectionStats objectForKey:@"userID"];
    NSString *firstName = [individualConnectionStats objectForKey:@"userFirstName"];
    NSString *lastName = [individualConnectionStats objectForKey:@"userLastName"];
    int correctAnswers = [[individualConnectionStats objectForKey:@"correctAnswers"] integerValue];
    int incorrectAnswers = [[individualConnectionStats objectForKey:@"incorrectAnswers"] integerValue];
    NSLog(@"%@ %@ | %@ | %d | %d",firstName,lastName,userID,correctAnswers,incorrectAnswers);
  }
}

+ (void)addStatsWithLoggedInUserID:(NSString *)ID{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:ID] mutableCopy];
  int currentRank = [[stats objectForKey:@"currentRank"] integerValue];
  currentRank++;
    
  NSMutableArray *connectionStats = [[stats objectForKey:@"connectionStats"] mutableCopy];
  
  NSMutableDictionary *individualConnectionStats = [NSMutableDictionary dictionary];
  NSString *userID = @"432121234";
  NSString *userFirstName = @"Tim";
  NSString *userLastName = @"Dredge";
  NSNumber *correctAnswers = [NSNumber numberWithInt:13];
  NSNumber *incorrectAnswers = [NSNumber numberWithInt:12];
  [individualConnectionStats setObject:userID forKey:@"userID"];
  [individualConnectionStats setObject:userFirstName forKey:@"userFirstName"];
  [individualConnectionStats setObject:userLastName forKey:@"userLastName"];
  [individualConnectionStats setObject:correctAnswers forKey:@"correctAnswers"];
  [individualConnectionStats setObject:incorrectAnswers forKey:@"incorrectAnswers"];
  
  [connectionStats addObject:individualConnectionStats];
  
  [stats setObject:[NSNumber numberWithInt:currentRank] forKey:@"currentRank"];
  [stats setObject:connectionStats forKey:@"connectionStats"];
  
  [prefs setObject:stats forKey:ID];

  [prefs synchronize];
  return;
}

+ (void)resetStatsWithLoggedInUserID:(NSString *)ID{
  [self setUpStatsWithNewLoggedInUserID:ID];
  return;
}
+ (void)questionStatsUpdateWithLoggedInUserID:(NSString *)ID forConnectionInQuestionID:(NSString *) correct:(BOOL)correct{
  return;
}

+ (void)startQuiz:(NSString *)loggedInUserID{
  return;
}

+ (void)endQuiz:(NSString *)loggedInUserID scorePercent:(float)scorePercent{
  return;
}

+ (NSArray *)getPeopleKnowledgeStats:(NSString *)loggedInUser{
  NSArray *knowledgeStats = [[NSArray alloc] init];
  return  knowledgeStats;
}

+ (void)setUpStatsWithNewLoggedInUserID{
  
}

@end
