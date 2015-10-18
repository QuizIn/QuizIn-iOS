#import "LIHTTPClient.h"

#import "LIAuthenticatedRequestSerializer.h"

static NSString * const kAFLinkedInAPIBaseURLString = @"https://api.linkedin.com/v1/";

@implementation LIHTTPClient

+ (instancetype)sharedClient {
  static LIHTTPClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient =
        [[LIHTTPClient alloc]
         initWithBaseURL:[NSURL URLWithString:kAFLinkedInAPIBaseURLString] sessionConfiguration:nil];
  });
  return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration {
  self = [super initWithBaseURL:url sessionConfiguration:configuration];
  if (self) {
    self.requestSerializer = [LIAuthenticatedRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
  }
  return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *, id))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
  //NSLog(@"%@", parameters);
  return [super GET:URLString parameters:parameters success:success failure:failure];
}



@end
