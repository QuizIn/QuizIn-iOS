
#import "QIStatsTracker.h"

@implementation QIStatsTracker


//We can track
//Quizzes Started
//Quizzes Complete
//Completion percent
//How well you know each person
//Last score
//Average Score

+ (void)updateStatsWithID:(NSString *)ID questionType:(QuestionType *)questionType correct:(BOOL)correct{
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

@end