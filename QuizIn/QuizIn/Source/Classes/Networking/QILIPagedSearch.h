#import <Foundation/Foundation.h>

@class QIConnectionsStore;

@interface QILIPagedSearch : NSObject
@property(nonatomic, copy) NSArray *facetValues;
@property(nonatomic, strong, readonly) QIConnectionsStore *resultsConnectionsStore;

- (instancetype)initWithFacetValues:(NSArray *)facetValues;
- (void)searchWithOnCompletion:(void (^)(NSError *error))onCompletion;
@end
