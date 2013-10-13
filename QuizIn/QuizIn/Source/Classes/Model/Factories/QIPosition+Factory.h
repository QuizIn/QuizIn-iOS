#import "QIPosition.h"

@interface QIPosition (Factory)

+ (QIPosition *)positionWithJSON:(NSDictionary *)positionJSON;

@end
