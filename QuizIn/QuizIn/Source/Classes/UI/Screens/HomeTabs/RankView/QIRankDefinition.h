
#import <Foundation/Foundation.h>

@interface QIRankDefinition : NSObject

+ (NSArray *)getRankDelineations; 
+ (UIImage *)getRankBadgeForRank:(int)rank;
+ (NSString *)getRankDescriptionForRank:(int)rank;
+ (NSArray *)getAllRankBadges;
+ (NSArray *)getAllRankDescriptions; 

@end
