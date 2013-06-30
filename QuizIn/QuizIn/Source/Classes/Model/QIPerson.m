#import "QIPerson.h"

@implementation QIPerson

- (NSString *)description {
  NSMutableString *description = [[super description] mutableCopy];

  [description appendFormat:@"id:%@\r", self.personID];
  [description appendFormat:@"firstName:%@\r", self.firstName];
  [description appendFormat:@"lastName:%@\r", self.lastName];
  [description appendFormat:@"industry:%@\r", self.industry];
  [description appendFormat:@"location:%@\r", self.location];
  [description appendFormat:@"positions:%@\r", self.positions];
  
  return [description copy];
}

@end
