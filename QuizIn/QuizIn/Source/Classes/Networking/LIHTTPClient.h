#import "AFHTTPClient.h"

#import "AFNetworkingBlockTypes.h"

@interface LIHTTPClient : AFHTTPClient

+ (instancetype)sharedClient;

@end
