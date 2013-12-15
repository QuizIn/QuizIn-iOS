#import "QISchool.h"

@implementation QISchool

- (id)copyWithZone:(NSZone *)zone {
  QISchool *school = [[[self class] allocWithZone:zone] init];
  
  school.code = [self.code copy];
  school.name = [self.name copy];
  
  return school;
}

- (NSString *)description {
  NSMutableString *description = [[super description] mutableCopy];
  
  [description appendFormat:@"\r\r code:%@\r", self.code];
  [description appendFormat:@"name:%@\r", self.name];
  
  return [description copy];
}

@end
