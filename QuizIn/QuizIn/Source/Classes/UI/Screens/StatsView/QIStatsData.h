
#import <Foundation/Foundation.h>

@interface QIStatsData : NSObject


- (id)initWithLoggedInUserID:(NSString *)ID;

//debug test functions
- (void)printStats;

//reset Stats
- (void)setUpStats;

//gets Stats
- (int)getCurrentRank;
- (int)getTotalCorrectAnswers;
- (int)getTotalIncorrectAnswers;
- (NSArray *)getConnectionStats;

//update Stats
- (void)updateStatsWithConnectionProfile:(NSDictionary *)connectionProfile correct:(BOOL)correct;

@end
