
#import "QIRankDefinition.h"

@implementation QIRankDefinition

+ (NSArray *)getRankDelineations{
  return  [NSArray arrayWithObjects:
            [NSNumber numberWithInt:0],
            [NSNumber numberWithInt:5],
            [NSNumber numberWithInt:10],
            [NSNumber numberWithInt:15],
            [NSNumber numberWithInt:30],
            [NSNumber numberWithInt:50],
            [NSNumber numberWithInt:100],
            [NSNumber numberWithInt:200],nil];
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
      break;
  }
  
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
      break;
  }
}

@end
