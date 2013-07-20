
#import <Foundation/Foundation.h>

@interface QIStatsData : NSObject

+ (void)setUpStatsWithNewLoggedInUserID:(NSString *)ID;
+ (void)printStatsOfID:(NSString *)ID;
+ (void)addStatsWithLoggedInUserID:(NSString *)ID;


@end
