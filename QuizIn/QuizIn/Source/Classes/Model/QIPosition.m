#import "QIPosition.h"

#import "QICompany.h"

@implementation QIPosition

- (id)copyWithZone:(NSZone *)zone {
  QIPosition *position = [[[self class] allocWithZone:zone] init];
  
  position.positionID = [self.positionID copy];
  position.company = [self.company copy];
  position.isCurrent = self.isCurrent;
  position.startDate = [self.startDate copy];
  position.title = [self.title copy];
  
  return position;
}

- (NSString *)description {
  NSMutableString *description = [[super description] mutableCopy];
  
  [description appendFormat:@"\r\r id:%@\r", self.positionID];
  [description appendFormat:@"company:%@\r", self.company];
  [description appendFormat:@"isCurrent:%d\r", self.isCurrent];
  [description appendFormat:@"startDate:%@\r", self.startDate];
  [description appendFormat:@"title:%@\r", self.title];
  
  return [description copy];
}

@end
