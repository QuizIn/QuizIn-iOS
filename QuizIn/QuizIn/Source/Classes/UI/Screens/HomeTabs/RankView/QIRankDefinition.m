
#import "QIRankDefinition.h"

@implementation QIRankDefinition

+ (NSArray *)getRankDelineations{
  return  [NSArray arrayWithObjects:
            [NSNumber numberWithInt:0],
            [NSNumber numberWithInt:3],
            [NSNumber numberWithInt:6],
            [NSNumber numberWithInt:9],
            [NSNumber numberWithInt:12],
            [NSNumber numberWithInt:15],
            [NSNumber numberWithInt:17],
            [NSNumber numberWithInt:23],nil];
}

+ (UIImage *)getRankBadgeForRank:(int)rank{
  switch (rank) {
    case 0:
      return [UIImage imageNamed:@"calendar_checkmark"];
      break;
    case 1:
      return [UIImage imageNamed:@"calendar_expand_btn1"];
      break;
    case 2:
      return [UIImage imageNamed:@"match_tape"];
      break;
    case 3:
      return [UIImage imageNamed:@"match_answerbox_std"];
      break;
    case 4:
      return [UIImage imageNamed:@"placeholderHead"];
      break;
    case 5:
      return [UIImage imageNamed:@"quizin_exit_btn"];
      break;
    case 6:
      return [UIImage imageNamed:@"calendar_checkmark"];
      break;
    case 7:
      return [UIImage imageNamed:@"calendar_checkmark"];
      break;
    case 8:
      return [UIImage imageNamed:@"calendar_checkmark"];
      break;
    default:
      return [UIImage imageNamed:@"calendar_checkmark"];
      break;
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
  switch (rank) {
    case 0:
      return @"Zero Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 1:
      return @"First Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 2:
      return @"Second Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 3:
      return @"Third Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 4:
      return @"Fourth Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 5:
      return @"Fifth Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 6:
      return @"Sixth Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 7:
      return @"Zeventh Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    case 8:
      return @"Eigth Rank Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod.";
      break;
    default:
      return @"This Rank is Off the Charts";
      break;
  }
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
