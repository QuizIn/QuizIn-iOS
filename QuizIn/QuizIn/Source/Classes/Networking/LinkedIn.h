#import <Foundation/Foundation.h>

@class QIConnectionsStore;

typedef void (^LIGetPeopleResponse)(NSDictionary *profile, NSError *error);
typedef void (^LIGetPeopleCurrentConnectionsResponse)(NSArray *connections,
                                                      NSError *error);
typedef void (^LIRandomConnectionsResponse)(QIConnectionsStore *connectionsStore, NSError *error);
typedef void (^LIConnectionsCountResult)(NSInteger numberOfConnections, NSError *error);

@interface LinkedIn : NSObject

+ (void)getPeopleCurrentUserWithCompletionHandler:
    (LIGetPeopleResponse)completionHandler;

+ (void)getPeopleCurrentUserConnectionsCountWithOnSuccess:(void (^)(NSInteger numberOfConnections))onSuccess
                                                onFailure:(void (^)(NSError *error))onFailure;

+ (void)getPeopleWithID:(NSString *)ID
      completionHandler:(LIGetPeopleResponse)completionHandler;

+ (void)getPeopleConnectionsWithCompletionHandler:
    (LIGetPeopleCurrentConnectionsResponse)completionHandler;

+ (void)getPeopleConnectionsWithStartIndex:(NSUInteger)startIndex
                                     count:(NSUInteger)count
                                 onSuccess:(void (^)(QIConnectionsStore *connections))onSuccess
                                 onFailure:(void (^)(NSError *error))onFailure;

+ (void)randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:(NSInteger)numberOfConnectionsToFetch
                                                               onCompletion:(LIRandomConnectionsResponse)onCompletion;

+ (void)numberOfConnectionsForAuthenticatedUserOnCompletion:(LIConnectionsCountResult)onCompletion;



@end
