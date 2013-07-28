#import <Foundation/NSOrderedSet.h>

@interface QIShuffleSet : NSObject
@property(nonatomic, strong, readonly) NSOrderedSet *orderedSet;

- (void)shuffleAddObject:(id)object;
- (void)shuffleAddObject:(id)object quantity:(NSInteger)quantity;
- (id)shuffleNextObject;
- (NSArray *)shuffledArray;
@end
