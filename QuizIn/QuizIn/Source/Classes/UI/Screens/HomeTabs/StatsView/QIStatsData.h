
#import <Foundation/Foundation.h>
#import "QIPerson.h"

@interface QIStatsData : NSObject

typedef enum SortBy: NSInteger SortBy;
enum SortBy : NSInteger {
  lastName,
  firstName,
  correctAnswers,
  incorrectAnswers,
  trend,
  known
};

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
- (NSArray *)getConnectionStatsInOrderBy:(SortBy)sortBy;
- (NSArray *)getConnectionStatsByKnownGroupings;
- (NSInteger)getWellKnownThreshold;
- (NSArray *)getRefreshPeopleIDsWithLimit:(int)limit;

//update Stats
- (void)updateStatsWithConnectionProfile:(QIPerson *)person correct:(BOOL)correct;
- (BOOL)needsRankUpdate;

@end
