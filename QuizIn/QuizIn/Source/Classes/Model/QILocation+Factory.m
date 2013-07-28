#import "QILocation+Factory.h"

@implementation QILocation (Factory)

+ (QILocation *)locationWithJSON:(NSDictionary *)locationJSON {
  QILocation *location = [QILocation new];
  location.countryCode = locationJSON[@"country"][@"code"];
  location.name = locationJSON[@"name"];
  return location;
}

@end
