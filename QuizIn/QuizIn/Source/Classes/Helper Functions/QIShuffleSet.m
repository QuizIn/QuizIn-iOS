#import "QIShuffleSet.h"

@interface QIShuffleSet ()
@property(nonatomic, strong) NSMutableOrderedSet *backingSet;
@property(nonatomic, assign) NSInteger shuffleCursor;
@end

@implementation QIShuffleSet

- (id)init {
  self = [super init];
  if (self) {
    _backingSet = [NSMutableOrderedSet orderedSet];
    _shuffleCursor = 0;
  }
  return self;
}

- (void)shuffleAddObject:(id)object {
  [self shuffleAddObject:object quantity:1];
}

- (void)shuffleAddObject:(id)object quantity:(NSInteger)quantity {
  if (quantity > 0) {
    NSInteger position = [self.backingSet count];
    for (NSInteger i = 0; i < quantity; i++) self.backingSet[position + i] = object;
    self.shuffleCursor = [self.backingSet count] - 1;
    
  } else {
    [[NSException exceptionWithName:NSInvalidArgumentException
                             reason:@"NSMutable array shuffle quantity in add must be greater than 0"
                           userInfo:nil] raise];
  }
}

- (id)shuffleNextObject {
  if (self.shuffleCursor < 1) {
    self.shuffleCursor = [self.backingSet count] - 1;
    return self.backingSet[0];
  }
  NSInteger randomIndex = arc4random_uniform(self.shuffleCursor + 1);
  [self.backingSet exchangeObjectAtIndex:randomIndex withObjectAtIndex:self.shuffleCursor];
  return self.backingSet[self.shuffleCursor--];
}

- (NSOrderedSet *)orderedSet {
  return [self.backingSet copy];
}

- (NSArray *)shuffledArray {
  NSMutableArray *shuffledArray = [NSMutableArray arrayWithCapacity:[self.backingSet count]];
  for (NSInteger i = 0; i < [self.backingSet count]; i++) {
    [shuffledArray addObject:[self shuffleNextObject]];
  }
  return [shuffledArray copy];
}

@end
