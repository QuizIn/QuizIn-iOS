#import <Foundation/Foundation.h>

typedef void (^LIGetPeopleResponse)(NSDictionary *profile, NSError *error);
typedef void (^LIGetPeopleCurrentConnectionsResponse)(NSArray *connections,
                                                      NSError *error);

@interface LinkedIn : NSObject

+ (void)getPeopleCurrentWithCompletionHandler:
    (LIGetPeopleResponse)completionHandler;

+ (void)getPeopleWithID:(NSString *)ID
      completionHandler:(LIGetPeopleResponse)completionHandler;

+ (void)getPeopleCurrentConnectionsWithCompletionHandler:
    (LIGetPeopleCurrentConnectionsResponse)completionHandler;

@end
