#import "QICompany.h"

@interface QICompany (Factory)

+ (QICompany *)companyWithJSON:(NSDictionary *)companyJSON;

@end
