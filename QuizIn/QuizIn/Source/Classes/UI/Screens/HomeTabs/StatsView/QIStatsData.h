
#import <Foundation/Foundation.h>
#import "QIPerson.h"

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
- (void)updateStatsWithConnectionProfile:(QIPerson *)person correct:(BOOL)correct;
- (BOOL)needsRankUpdate;

@end
