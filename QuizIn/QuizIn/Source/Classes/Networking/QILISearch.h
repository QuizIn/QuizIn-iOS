#import <Foundation/Foundation.h>

@class QILISearchResultData;

typedef void (^QISearchResult)(QILISearchResultData *result, NSError *error);
typedef void (^QISearchFacetResult)(NSArray *facets, NSError *error);

@interface QILISearch : NSObject

+ (void)getPeopleSearchWithFieldSelector:(NSString *)fieldSelector
                        searchParameters:(NSDictionary *)searchParameters
                            onCompletion:(QISearchResult)onCompletion;

+ (void)getPeopleSearchFacets:(NSArray *)facets
         withSearchParameters:(NSDictionary *)searchParameters
                 onCompletion:(QISearchFacetResult)onCompletion;

@end

@interface QILISearchResultData : NSObject
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger start;
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, copy) NSArray *peopleJSON;
@end