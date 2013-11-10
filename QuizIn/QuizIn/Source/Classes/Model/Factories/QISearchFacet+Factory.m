#import "QISearchFacet+Factory.h"

#import "QISearchFacetBucket.h"

@implementation QISearchFacet (Factory)

+ (QISearchFacet *)facetWithJSON:(NSDictionary *)facetJSON {
  QISearchFacet *facet = [QISearchFacet new];
  facet.name = facetJSON[@"name"];
  facet.code = facetJSON[@"code"];
  
  NSMutableArray *buckets = [NSMutableArray array];
  NSArray *bucketsJSON = facetJSON[@"buckets"][@"values"];
  for (NSDictionary *bucketJSON in bucketsJSON) {
    QISearchFacetBucket *bucket = [QISearchFacetBucket new];
    bucket.code = bucketJSON[@"code"];
    bucket.count = bucketJSON[@"count"];
    bucket.name = bucketJSON[@"name"];
    [buckets addObject:bucket];
  }
  facet.buckets = [buckets copy];
  
  return facet;
}

@end
