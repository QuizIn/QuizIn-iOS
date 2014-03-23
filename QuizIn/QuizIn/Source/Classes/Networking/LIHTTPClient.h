#import <AFNetworking/AFNetworking.h>

#import "AFNetworkingBlockTypes.h"

@interface LIHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
