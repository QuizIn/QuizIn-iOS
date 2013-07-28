#import <AFNetworking/AFHTTPRequestOperation.h>

typedef void (^AFHTTPRequestOperationSuccess)(AFHTTPRequestOperation *operation,
                                              id responseObject);

typedef void (^AFHTTPRequestOperationFailure)(AFHTTPRequestOperation *operation,
                                              NSError *error);



