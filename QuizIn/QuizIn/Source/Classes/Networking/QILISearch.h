#import <Foundation/Foundation.h>

typedef void (^QISearchResult)(NSArray *people, NSError *error);

@interface QILISearch : NSObject

+ (void)getPeopleSearchWithFieldSelector:(NSString *)fieldSelector
                        searchParameters:(NSDictionary *)searchParameters
                            onCompletion:(QISearchResult)onCompletion;

@end
