#import <Foundation/Foundation.h>

@class QIConnectionsStore;

typedef void (^LIGetPeopleResponse)(NSDictionary *profile, NSError *error);
typedef void (^LIGetPeopleCurrentConnectionsResponse)(NSArray *connections,
                                                      NSError *error);
typedef void (^LIRandomConnectionsResponse)(QIConnectionsStore *connectionsStore, NSError *error);
typedef void (^LIConnectionsCountResult)(NSInteger numberOfConnections, NSError *error);

@interface LinkedIn : NSObject
+ (void)randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:(NSInteger)numberOfConnectionsToFetch
                                                               onCompletion:(LIRandomConnectionsResponse)onCompletion;

+ (void)numberOfConnectionsForAuthenticatedUserOnCompletion:(LIConnectionsCountResult)onCompletion;
@end
