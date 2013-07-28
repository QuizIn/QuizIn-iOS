
#import "QIStatsData.h"
#import "QIRankDefinition.h"

@interface QIStatsData ()
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSArray *ranks;
@end

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
  // key:updateRank               BOOL
  // key:TotalCorrectAnswers      Integer
  // key:TotalIncorrectAnswers    Integer
  // key:IndividualStats          Array
        //Array Elements            Dictionary
      //key:UserID              NSString
      //key:UserPictureID       NSString
      //key:UserFirstName       NSString
      //key:UserLastName        NSString
      //key:CorrectAnswers      Integer
      //key:IncorrectAnswers    Integer
*/

- (id)initWithLoggedInUserID:(NSString *)ID{
  self = [super init];
  if (self) {
    _userID = ID;
    _ranks = [QIRankDefinition getRankDelineations];
    
  }
  return self;
}



//reset Stats

- (void)setUpStats{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  
  NSNumber *currentRank = [NSNumber numberWithInt:0];
  NSNumber *updateRank = [NSNumber numberWithBool:NO];
  NSNumber *totalCorrectAnswers = [NSNumber numberWithInt:0];
  NSNumber *totalIncorrectAnswers = [NSNumber numberWithInt:0];
  NSMutableArray *connectionStats = [NSMutableArray array];
  
  NSMutableDictionary *userStats = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    currentRank,            @"currentRank",
                                    updateRank,             @"updateRank",
                                    totalCorrectAnswers,    @"totalCorrectAnswers",
                                    totalIncorrectAnswers,  @"totalIncorrectAnswers",
                                    connectionStats,        @"connectionStats",
                                    nil];
  
  [prefs setObject:userStats forKey:self.userID];
  [prefs synchronize];
}


//debug functions

- (void)printStats{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
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


//get stats (primary for stats view)

- (int)getCurrentRank{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  return [[stats objectForKey:@"currentRank"] integerValue];
}

- (int)getTotalCorrectAnswers{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  return [[stats objectForKey:@"totalCorrectAnswers"] integerValue];
}

- (int)getTotalIncorrectAnswers{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  return [[stats objectForKey:@"totalIncorrectAnswers"] integerValue];
}

- (NSArray *)getConnectionStats {
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  return [stats objectForKey:@"connectionStats"];
}




//stats Analytics events
- (void)updateStatsWithConnectionProfile:(QIPerson *)person correct:(BOOL)correct{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  
  //Handle Total Correct and Incorrect Answers
  int totalCorrectAnswers = [[stats objectForKey:@"totalCorrectAnswers"] integerValue];
  int totalIncorrectAnswers = [[stats objectForKey:@"totalIncorrectAnswers"] integerValue];
  
  if (correct) {
    totalCorrectAnswers++;
  }
  else{
    totalIncorrectAnswers++;
  }
  
  //Handle Rank
  if (correct){
    for (int i = 0; i<[self.ranks count]; i++){
      NSNumber *rankCorrectAnswers = [self.ranks objectAtIndex:i];
      if ([rankCorrectAnswers integerValue] == totalCorrectAnswers){
        [stats setObject:[NSNumber numberWithBool:YES] forKey:@"updateRank"];
        [stats setObject:[NSNumber numberWithInt:i] forKey:@"currentRank"];
      }
    }
  }
  //Handle Individual Connections Stats
  NSMutableArray *connectionStats = [[stats objectForKey:@"connectionStats"] mutableCopy];
  NSUInteger connectionIndex = [connectionStats indexOfObjectPassingTest:^ (id obj, NSUInteger idx, BOOL *stop)
                       {
                         NSMutableDictionary *connectionTest = (NSMutableDictionary *)obj;
                         NSString *testID = [connectionTest objectForKey:@"userID"];
                         if ([testID isEqualToString:person.personID]){
                           return YES;
                         }
                         else{
                           return NO;
                         }
                        }];
  if (connectionIndex != NSNotFound) {
    NSMutableDictionary *individualConnectionStats = [[connectionStats objectAtIndex:connectionIndex] mutableCopy];
    if (correct) {
      int correctAnswers = [[individualConnectionStats objectForKey:@"correctAnswers"] integerValue];
      correctAnswers++;
      [individualConnectionStats setObject:[NSNumber numberWithInt:correctAnswers] forKey:@"correctAnswers"];
    }
    else{
      int incorrectAnswers = [[individualConnectionStats objectForKey:@"incorrectAnswers"] integerValue];
      incorrectAnswers++;
      [individualConnectionStats setObject:[NSNumber numberWithInt:incorrectAnswers] forKey:@"incorrectAnswers"];
    }
    [connectionStats replaceObjectAtIndex:connectionIndex withObject:individualConnectionStats];
  }
  else {
    int correctAnswers;
    int incorrectAnswers;
    if (correct) {
      correctAnswers = 1;
      incorrectAnswers = 0;
    }
    else{
      correctAnswers = 0;
      incorrectAnswers = 1;
    }
    
    NSMutableDictionary *individualConnectionStatsNew = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         person.pictureURL,                         @"userPictureURL",
                                                         person.personID,                           @"userID",
                                                         person.firstName,                          @"userFirstName",
                                                         person.lastName,                           @"userLastName",
                                                         [NSNumber numberWithInt:correctAnswers],   @"correctAnswers",
                                                         [NSNumber numberWithInt:incorrectAnswers], @"incorrectAnswers",
                                                         nil];
    [connectionStats addObject:individualConnectionStatsNew];
  }
  [stats setObject:[NSNumber numberWithInt:totalCorrectAnswers] forKey:@"totalCorrectAnswers"];
  [stats setObject:[NSNumber numberWithInt:totalIncorrectAnswers] forKey:@"totalIncorrectAnswers"];
  [stats setObject:connectionStats forKey:@"connectionStats"];
  NSLog(@"Correct:%d Incorrect:%d Rank:%d Update:%d",[[stats objectForKey:@"totalCorrectAnswers"] integerValue],[[stats objectForKey:@"totalIncorrectAnswers"] integerValue],[[stats objectForKey:@"currentRank"] integerValue],[[stats objectForKey:@"updateRank"] integerValue]);
  
  [prefs setObject:stats forKey:self.userID];
  [prefs synchronize];
}

- (BOOL)needsRankUpdate{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  BOOL needsUpdate = [[stats objectForKey:@"updateRank"] boolValue];
  [stats setObject:[NSNumber numberWithBool:NO] forKey:@"updateRank"];
  [prefs setObject:stats forKey:self.userID];
  [prefs synchronize];
  return needsUpdate;
}

@end
