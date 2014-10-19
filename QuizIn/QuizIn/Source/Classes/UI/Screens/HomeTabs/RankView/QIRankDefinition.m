
#import "QIRankDefinition.h"
#import "QIStatsData.h"
#import "LinkedIn.h"

@implementation QIRankDefinition

+ (NSArray *)getRankDelineations{
  return  [NSArray arrayWithObjects:
            [NSNumber numberWithInt:5],
            [NSNumber numberWithInt:20],
            [NSNumber numberWithInt:50],
            [NSNumber numberWithInt:100],
            [NSNumber numberWithInt:200],
            [NSNumber numberWithInt:350],
            [NSNumber numberWithInt:600],
            [NSNumber numberWithInt:1000],
            [NSNumber numberWithInt:1600],
            [NSNumber numberWithInt:3000], nil];
}

+ (UIImage *)getRankBadgeForRank:(int)rank{
  //todo: get actual userID
  NSString *userID = [LinkedIn authenticatedUser].personID;
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:userID];
  int currentRank = [data getCurrentRank];
  if (rank > currentRank){
    return [UIImage imageNamed:@"hobnob_rankings_inactive_btn"];
  }
  else {
    switch (rank) {
      case 0:
        return [UIImage imageNamed:@"hobnob_rankings_intern_active_btn"];
        break;
      case 1:
        return [UIImage imageNamed:@"hobnob_rankings_associate_active_btn"];
        break;
      case 2:
        return [UIImage imageNamed:@"hobnob_rankings_manager_active_btn"];
        break;
      case 3:
        return [UIImage imageNamed:@"hobnob_rankings_supervisor_active_btn"];
        break;
      case 4:
        return [UIImage imageNamed:@"hobnob_rankings_director_active_btn"];
        break;
      case 5:
        return [UIImage imageNamed:@"hobnob_rankings_vicepresident_active_btn"];
        break;
      case 6:
        return [UIImage imageNamed:@"hobnob_rankings_president_active_btn"];
        break;
      case 7:
        return [UIImage imageNamed:@"hobnob_rankings_coo_active_btn"];
        break;
      case 8:
        return [UIImage imageNamed:@"hobnob_rankings_ceo_active_btn"];
        break;
      case 9:
        return [UIImage imageNamed:@"hobnob_rankings_chairman_active_btn"];
        break;
        
      default:
        return [UIImage imageNamed:@"hobnob_rankings_chairman_active_btn"];
        break;
    }
  }
}

+ (NSArray *)getAllRankBadges{
  NSMutableArray *all = [NSMutableArray array];
  NSArray *delineations = [self getRankDelineations];
  for (int i = 0;i<[delineations count];i++){
    [all addObject:[self getRankBadgeForRank:i]];
  }
  return [all copy];
}

+ (NSString *)getRankDescriptionForRank:(int)rank{
  NSArray *delineations = [self getRankDelineations];
  return [NSString stringWithFormat:@"%d Correct Answers",[[delineations objectAtIndex:rank] intValue]];
}

+ (NSArray *)getAllRankDescriptions{
  NSMutableArray *all = [NSMutableArray array];
  NSArray *delineations = [self getRankDelineations];
  for (int i = 0;i<[delineations count];i++){
    [all addObject:[self getRankDescriptionForRank:i]];
  }
  return [all copy];
}

@end
