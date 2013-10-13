#import "QILocation.h"

@interface QILocation (Factory)

+ (QILocation *)locationWithJSON:(NSDictionary *)locationJSON;

@end
