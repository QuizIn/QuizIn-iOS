#import "QIPerson.h"

@interface QIPerson (Factory)

+ (QIPerson *)personWithJSON:(NSDictionary *)personJSON;

@end
