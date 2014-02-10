
#import "QIStatsData.h"
#import "QIRankDefinition.h"

@interface QIStatsData ()
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSArray *ranks;

@end

@implementation QIStatsData

//Rules
//Well Known Index - 3 or more
//Sorta Known - 0-3
//Needs Refresh - < 0

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
  // key:totalCorrectAnswers      Integer
  // key:totalIncorrectAnswers    Integer
  // key:connectionStats          Array
        //Array Elements            Dictionary
      //key:userID              NSString
      //key:userPictureID       NSString
      //key:userFirstName       NSString
      //key:userLastName        NSString
      //key:correctAnswers      Integer
      //key:incorrectAnswers    Integer
      //key:lastDirection       BOOL
*/

#define WELL_KNOWN_THRESHOLD 3 

- (id)initWithLoggedInUserID:(NSString *)ID{
  self = [super init];
  if (self) {
    _userID = ID;
    _ranks = [QIRankDefinition getRankDelineations];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //todo rkuhlman offline usage
    //_userID = @"12345";//
    if (_userID != nil){
      if (![prefs objectForKey:_userID]){
        [self setUpStats];
      }
    }
  }
  return self;
}



#pragma mark Actions

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

#pragma mark Get Stats

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

- (NSInteger)getWellKnownThreshold{
  return WELL_KNOWN_THRESHOLD; 
}

- (NSArray *)getRefreshPeopleIDsWithLimit:(int)limit{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  NSMutableArray *connectionStats = [stats objectForKey:@"connectionStats"];
  NSMutableArray *refreshPeople = [NSMutableArray array];
  for (int i = 0; i<[connectionStats count];i++){
    NSDictionary *connection = [connectionStats objectAtIndex:i];
    NSInteger correctAnswers = [[connection objectForKey:@"correctAnswers"] integerValue];
    NSInteger incorrectAnswers = [[connection objectForKey:@"incorrectAnswers"] integerValue];
    NSInteger knownIndex = correctAnswers - incorrectAnswers;
    if (knownIndex < 0){
      [refreshPeople addObject:[connection objectForKey:@"userID"]];
      if ([refreshPeople count] == limit){
        break;
      }
    }
  }
  return [refreshPeople copy];
}


- (NSArray *)getConnectionStatsInOrderBy:(SortBy)sortBy{
  
  NSString *sortKey = @"userLastName";
  switch (sortBy) {
    case lastName:{
      sortKey = @"userLastName";
      break;
    }
    case firstName:{
      sortKey = @"userFirstName";
      break;
    }
    case correctAnswers:{
      sortKey = @"correctAnswers";
      break;
    }
    case incorrectAnswers:{
      sortKey = @"incorrectAnswers";
      break; 
    }
    case trend:{
      sortKey = @"lastDirection";
      break; 
    }
    case known:{
      sortKey = @"userLastName";
      break; 
    }
    default:
      break;
  }
  //Array - connectionStatsAlphabetical
    //Elements: Dictionary - connectionStatsLetter
      //String - letter
      //Array - letterConnections
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  NSMutableArray *connectionStats = [stats objectForKey:@"connectionStats"];
  NSSortDescriptor *intermediateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userLastName" ascending:YES];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
  NSArray *sortDescriptors = @[sortDescriptor, intermediateSortDescriptor];
  NSArray *sortedConnectionStats = [connectionStats sortedArrayUsingDescriptors:sortDescriptors];

  NSMutableDictionary *connectionStatsAlphabetical = [NSMutableDictionary dictionary];
  NSMutableArray *sections = [NSMutableArray array];
  
  if (sortBy == lastName | sortBy == firstName){
    for (NSDictionary *connection in sortedConnectionStats){
      NSString *name = [connection objectForKey:sortKey];
      NSString *letter = @"";
      if ([name length]>0){
        unichar character = [name characterAtIndex:0];
        letter = [NSString stringWithFormat:@"%C", character];
        letter = [letter uppercaseString];
      }
      else{
        letter = @" ";
      }
      NSUInteger index = [sections indexOfObject:letter];
      if (index == NSNotFound) {
        [sections addObject:letter];
        NSMutableArray *sectionList = [NSMutableArray arrayWithObject:connection];
        [connectionStatsAlphabetical setObject:sectionList forKey:letter];
      }
      else{
        [[connectionStatsAlphabetical objectForKey:letter] addObject:connection];
      }
    }
  }
  
  if (sortBy == correctAnswers | sortBy == incorrectAnswers){
    NSString *referenceString; 
    if (sortBy == correctAnswers)
      referenceString = @"%d Correct Answers";
    else if (sortBy == incorrectAnswers)
      referenceString = @"%d Incorrect Answers";
    
    for (NSDictionary *connection in sortedConnectionStats){
      int sectionNumber = [[connection objectForKey:sortKey] integerValue];
      NSString *numberString = [NSString stringWithFormat:referenceString,sectionNumber];
      if (sectionNumber == 1){
        numberString = [numberString substringToIndex:[numberString length] -1]; 
      }
      NSUInteger index = [sections indexOfObject:numberString];
      if (index == NSNotFound) {
        [sections addObject:numberString];
        NSMutableArray *sectionList = [NSMutableArray arrayWithObject:connection];
        [connectionStatsAlphabetical setObject:sectionList forKey:numberString];
      }
      else{
        [[connectionStatsAlphabetical objectForKey:numberString] addObject:connection];
      }
    }
  }
  
  if (sortBy == trend){
    for (NSDictionary *connection in sortedConnectionStats){
      NSString *sectionString;
      if ([[connection objectForKey:sortKey] boolValue])
        sectionString = @"Trending Up";
      else
        sectionString = @"Trending Down";
      
      NSUInteger index = [sections indexOfObject:sectionString];
      if (index == NSNotFound) {
        [sections addObject:sectionString];
        NSMutableArray *sectionList = [NSMutableArray arrayWithObject:connection];
        [connectionStatsAlphabetical setObject:sectionList forKey:sectionString];
      }
      else{
        [[connectionStatsAlphabetical objectForKey:sectionString] addObject:connection];
      }
    }
  }

  else if (sortBy == known){
    NSMutableIndexSet *wellKnownIndexes = [[NSMutableIndexSet alloc] init];
    NSMutableIndexSet *middleKnownIndexes = [[NSMutableIndexSet alloc] init];
    NSMutableIndexSet *needsRefreshIndexes = [[NSMutableIndexSet alloc] init];
    for (int i = 0; i<[sortedConnectionStats count];i++){
      NSDictionary *connection = [sortedConnectionStats objectAtIndex:i];
      NSInteger correctAnswers = [[connection objectForKey:@"correctAnswers"] integerValue];
      NSInteger incorrectAnswers = [[connection objectForKey:@"incorrectAnswers"] integerValue];
      NSInteger knownIndex = correctAnswers - incorrectAnswers;
      if (knownIndex >= WELL_KNOWN_THRESHOLD)
        [wellKnownIndexes addIndex:i];
      else if (knownIndex >=0 && knownIndex < WELL_KNOWN_THRESHOLD)
        [middleKnownIndexes addIndex:i];
      else
        [needsRefreshIndexes addIndex:i];
    }
    NSArray *wellKnownConnections = [sortedConnectionStats objectsAtIndexes:wellKnownIndexes];
    NSArray *middleConnections = [sortedConnectionStats objectsAtIndexes:middleKnownIndexes];
    NSArray *needsRefreshConnections = [sortedConnectionStats objectsAtIndexes:needsRefreshIndexes];
    [sections addObjectsFromArray:@[@"Needs Refresh",@"Sorta Known",@"Well Known"]];
    [connectionStatsAlphabetical setObject:needsRefreshConnections forKey:[sections objectAtIndex:0]];
    [connectionStatsAlphabetical setObject:middleConnections forKey:[sections objectAtIndex:1]];
    [connectionStatsAlphabetical setObject:wellKnownConnections forKey:[sections objectAtIndex:2]];
  }
  return @[sections,connectionStatsAlphabetical];
}

- (NSArray *)getConnectionStatsByKnownGroupings{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSMutableDictionary *stats = [[prefs objectForKey:self.userID] mutableCopy];
  
  NSMutableArray *connectionStats = [stats objectForKey:@"connectionStats"];
  NSMutableIndexSet *wellKnownIndexes = [[NSMutableIndexSet alloc] init];
  NSMutableIndexSet *middleKnownIndexes = [[NSMutableIndexSet alloc] init];
  NSMutableIndexSet *needsRefreshIndexes = [[NSMutableIndexSet alloc] init];
  for (int i = 0; i<[connectionStats count];i++){
    NSDictionary *connection = [connectionStats objectAtIndex:i];
    NSInteger correctAnswers = [[connection objectForKey:@"correctAnswers"] integerValue];
    NSInteger incorrectAnswers = [[connection objectForKey:@"incorrectAnswers"] integerValue];
    NSInteger knownIndex = correctAnswers - incorrectAnswers;
    if (knownIndex >= WELL_KNOWN_THRESHOLD)
      [wellKnownIndexes addIndex:i];
    else if (knownIndex >=0 && knownIndex < WELL_KNOWN_THRESHOLD)
      [middleKnownIndexes addIndex:i];
    else
      [needsRefreshIndexes addIndex:i];
  }
  return @[wellKnownIndexes, middleKnownIndexes, needsRefreshIndexes];
}

#pragma Mark Update Stats

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
    BOOL lastDirection;
    NSMutableDictionary *individualConnectionStats = [[connectionStats objectAtIndex:connectionIndex] mutableCopy];
    if (correct) {
      int correctAnswers = [[individualConnectionStats objectForKey:@"correctAnswers"] integerValue];
      correctAnswers++;
      lastDirection = YES; 
      [individualConnectionStats setObject:[NSNumber numberWithInt:correctAnswers] forKey:@"correctAnswers"];
      [individualConnectionStats setObject:[NSNumber numberWithBool:lastDirection] forKey:@"lastDirection"];
    }
    else{
      int incorrectAnswers = [[individualConnectionStats objectForKey:@"incorrectAnswers"] integerValue];
      incorrectAnswers++;
      lastDirection = NO;
      [individualConnectionStats setObject:[NSNumber numberWithInt:incorrectAnswers] forKey:@"incorrectAnswers"];
      [individualConnectionStats setObject:[NSNumber numberWithBool:lastDirection] forKey:@"lastDirection"]; 
    }
    [connectionStats replaceObjectAtIndex:connectionIndex withObject:individualConnectionStats];
  }
  else {
    int correctAnswers;
    int incorrectAnswers;
    BOOL lastDirection; 
    if (correct) {
      correctAnswers = 1;
      incorrectAnswers = 0;
      lastDirection = YES; 
    }
    else{
      correctAnswers = 0;
      incorrectAnswers = 1;
      lastDirection = NO; 
    }
    
    NSMutableDictionary *individualConnectionStatsNew = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                         person.pictureURL,                         @"userPictureURL",
                                                         person.personID,                           @"userID",
                                                         person.firstName,                          @"userFirstName",
                                                         person.lastName,                           @"userLastName",
                                                         person.publicProfileURL,                   @"profileURL",
                                                         [NSNumber numberWithInt:correctAnswers],   @"correctAnswers",
                                                         [NSNumber numberWithInt:incorrectAnswers], @"incorrectAnswers",
                                                         [NSNumber numberWithBool:lastDirection],   @"lastDirection",
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
