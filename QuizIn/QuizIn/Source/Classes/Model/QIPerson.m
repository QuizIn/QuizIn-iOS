#import "QIPerson.h"

#import "QILocation.h"

@implementation QIPerson

- (id)copyWithZone:(NSZone *)zone {
  QIPerson *person = [[[self class] allocWithZone:zone] init];
  
  person.personID = [self.personID copy];
  person.firstName = [self.firstName copy];
  person.lastName = [self.lastName copy];
  person.industry = [self.industry copy];
  person.location = [self.location copy];
  person.positions = [self.positions copy];
  
  return person;
}

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
