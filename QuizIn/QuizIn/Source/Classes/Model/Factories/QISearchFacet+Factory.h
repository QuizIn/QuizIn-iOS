#import "QISearchFacet.h"

@interface QISearchFacet (Factory)

+ (QISearchFacet *)facetWithJSON:(NSDictionary *)facetJSON;

@end
