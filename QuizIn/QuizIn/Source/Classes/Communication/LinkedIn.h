#import <Foundation/Foundation.h>

typedef void (^LIGetPeopleCurrentResponse)(NSDictionary *profile, NSError *error);
typedef void (^LIGetPeopleCurrentConnectionsResponse)(NSArray *connections,
                                                      NSError *error);

@interface LinkedIn : NSObject

+ (void)getPeopleCurrentWithCompletionHandler:
    (LIGetPeopleCurrentResponse)completionHandler;

+ (void)getPeopleCurrentConnectionsWithCompletionHandler:
    (LIGetPeopleCurrentConnectionsResponse)completionHandler;

@end
