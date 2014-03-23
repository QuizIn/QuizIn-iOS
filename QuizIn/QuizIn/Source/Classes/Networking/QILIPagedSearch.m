#import "QILIPagedSearch.h"

#import "QILISearch.h"
#import "QIConnectionsStore.h"
#import "QIConnectionsStore+Factory.h"
#import "LinkedIn.h"


// TODO:Assert this number is never larger than 25.
static NSString * const kSearchResultsPerPage = @"25";

@interface QILIPagedSearch ()
@property(nonatomic, assign) BOOL canExecute;
@property(nonatomic, strong, readwrite) QIConnectionsStore *resultsConnectionsStore;
@property(nonatomic, strong) NSMutableArray *connections;
@end

@implementation QILIPagedSearch

- (instancetype)initWithFacetValues:(NSArray *)facetValues {
  self = [super init];
  if (self) {
    _canExecute = YES;
    _facetValues = [facetValues copy];
  }
  return self;
}

- (void)searchWithOnCompletion:(void (^)(NSError *error))onCompletion {
  NSAssert(self.canExecute == YES, @"Cannot execute same paged search more than once.");
  self.canExecute = NO;
  
  QISearchResult searchFirstPageOnCompletion = ^(QILISearchResultData *result, NSError *error){
    if (error != nil) {
      NSLog(@"Error fetching first page of search results, %@", error);
      onCompletion(error);
    }
    
    self.connections = [NSMutableArray arrayWithCapacity:result.total];
    [self.connections addObjectsFromArray:result.peopleJSON];
    
    NSInteger numberOfResultsPerPage = [kSearchResultsPerPage integerValue];
    if (result.total > numberOfResultsPerPage) {
      // Keep paging.
      NSInteger numberOfPages = ceilf((float)result.total / (float)numberOfResultsPerPage) - 1;
      __block NSInteger numberOfPagesReturned = 0;
      for (NSInteger i = numberOfResultsPerPage; i < result.total; i+=numberOfResultsPerPage) {
        QISearchResult searchPageOnCompletion = ^(QILISearchResultData *result, NSError *error){
          numberOfPagesReturned++;
          if (error == nil) {
            [self.connections addObjectsFromArray:result.peopleJSON];
          } // TODO(Rene): Handle error if one is returned.
          if (numberOfPagesReturned == numberOfPages) {
            self.resultsConnectionsStore = [QIConnectionsStore storeWithJSON:[self.connections copy]];
            onCompletion ? onCompletion(nil) : NULL;
          }
        };
        
        [QILISearch getPeopleSearchWithFieldSelector:[NSString stringWithFormat:@"people:(%@)", [LinkedIn peopleFieldSelector]]
                                    searchParameters:@{@"start": [NSString stringWithFormat:@"%@", @(i)],
                                                       @"count": kSearchResultsPerPage,
                                                       @"facet": [NSSet setWithObjects:@"network,F",
                                                                  [self.facetValues componentsJoinedByString:@","], nil]}
                                        onCompletion:searchPageOnCompletion];
      }
    } else {
      // Done paging.
      NSLog(@"Done");
      self.resultsConnectionsStore = [QIConnectionsStore storeWithJSON:[self.connections copy]];
      onCompletion ? onCompletion(nil) : NULL;
    }
  };
  
  
  [QILISearch getPeopleSearchWithFieldSelector:[NSString stringWithFormat:@"people:(%@)", [LinkedIn peopleFieldSelector]]
                              searchParameters:@{@"start": @"0",
                                                 @"count": kSearchResultsPerPage,
                                                 @"facet": [NSSet setWithObjects:@"network,F",
                                                            [self.facetValues componentsJoinedByString:@","], nil]}
                                  onCompletion:searchFirstPageOnCompletion];
  
}

@end
