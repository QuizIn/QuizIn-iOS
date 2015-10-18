
#import <AFNetworking/AFHTTPRequestOperation.h>

typedef void (^AFHTTPRequestOperationSuccess)(NSURLSessionDataTask *task, id responseObject);

typedef void (^AFHTTPRequestOperationFailure)(NSURLSessionDataTask *task, NSError *error);
