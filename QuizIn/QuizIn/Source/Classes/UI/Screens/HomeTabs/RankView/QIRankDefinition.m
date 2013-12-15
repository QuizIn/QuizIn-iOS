
#import "QIRankDefinition.h"
#import "QIStatsData.h"
#import "LinkedIn.h"

@implementation QIRankDefinition

+ (NSArray *)getRankDelineations{
  return  [NSArray arrayWithObjects:
            [NSNumber numberWithInt:1],
            [NSNumber numberWithInt:3],
            [NSNumber numberWithInt:6],
            [NSNumber numberWithInt:9],
            [NSNumber numberWithInt:12],
            [NSNumber numberWithInt:15],
            [NSNumber numberWithInt:17],
            [NSNumber numberWithInt:23],
            [NSNumber numberWithInt:25],
            [NSNumber numberWithInt:27], nil];
}

+ (UIImage *)getRankBadgeForRank:(int)rank{
  //todo: get actual userID
  NSString *userID = [LinkedIn authenticatedUser].personID;
  QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:userID];
  int currentRank = [data getCurrentRank];
  if (rank > currentRank){
    switch (rank) {
      case 0:
        return [UIImage imageNamed:@"hobnob_rankings_intern_inactive_btn"];
        break;
      case 1:
        return [UIImage imageNamed:@"hobnob_rankings_associate_inactive_btn"];
        break;
      case 2:
        return [UIImage imageNamed:@"hobnob_rankings_manager_inactive_btn"];
        break;
      case 3:
        return [UIImage imageNamed:@"hobnob_rankings_supervisor_inactive_btn"];
        break;
      case 4:
        return [UIImage imageNamed:@"hobnob_rankings_director_inactive_btn"];
        break;
      case 5:
        return [UIImage imageNamed:@"hobnob_rankings_vicepresident_inactive_btn"];
        break;
      case 6:
        return [UIImage imageNamed:@"hobnob_rankings_president_inactive_btn"];
        break;
      case 7:
        return [UIImage imageNamed:@"hobnob_rankings_coo_inactive_btn"];
        break;
      case 8:
        return [UIImage imageNamed:@"hobnob_rankings_ceo_inactive_btn"];
        break;
      case 9:
        return [UIImage imageNamed:@"hobnob_rankings_chairman_inactive_btn"];
        break;
      default:
        return [UIImage imageNamed:@"hobnob_rankings_chairman_inactive_btn"];
        break;
    }
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
