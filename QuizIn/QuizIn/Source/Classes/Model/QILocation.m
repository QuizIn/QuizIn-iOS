#import "QILocation.h"

@implementation QILocation

- (id)copyWithZone:(NSZone *)zone {
  QILocation *location = [[[self class] allocWithZone:zone] init];
  location.countryCode = [self.countryCode copy];
  location.name = [self.name copy];
  return location;
}

@end
