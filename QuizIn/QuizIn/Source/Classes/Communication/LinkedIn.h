#import <Foundation/Foundation.h>

@class QIConnections;

typedef void (^LIGetPeopleResponse)(NSDictionary *profile, NSError *error);
typedef void (^LIGetPeopleCurrentConnectionsResponse)(NSArray *connections,
                                                      NSError *error);

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
                                 onSuccess:(void (^)(QIConnections *connections))onSuccess
                                 onFailure:(void (^)(NSError *error))onFailure;

@end
