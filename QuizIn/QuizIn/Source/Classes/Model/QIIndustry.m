#import "QIIndustry.h"

@implementation QIIndustry

- (id)copyWithZone:(NSZone *)zone {
  QIIndustry*industry = [[[self class] allocWithZone:zone] init];
  
  industry.code = [self.code copy];
  industry.name = [self.name copy];
  
  return industry;
}

- (NSString *)description {
  NSMutableString *description = [[super description] mutableCopy];
  
  [description appendFormat:@"\r\r code:%@\r", self.code];
  [description appendFormat:@"name:%@\r", self.name];
  
  return [description copy];
}

@end
