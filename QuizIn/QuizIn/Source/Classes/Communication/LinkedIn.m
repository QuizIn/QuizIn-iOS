#import "LinkedIn.h"

#import <AuthKit/AKAccountStore.h>

#import "LIHTTPClient.h"
#import "AKLinkedInAuthController.h"

typedef void (^AFHTTPRequestOperationSuccess)(AFHTTPRequestOperation *operation,
                                              id responseObject);
typedef void (^AFHTTPRequestOperationFailure)(AFHTTPRequestOperation *operation,
                                              NSError *error);

@implementation LinkedIn

+ (void)getPeopleCurrentWithCompletionHandler:(LIGetPeopleResponse)completionHandler {
  NSString *path = @"people/~";
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    NSLog(@"LinkedIn: Profile, %@", JSON);
    completionHandler ? completionHandler(JSON, nil) : NULL;
  };
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    NSLog(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
        unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  [httpClient getPath:path parameters:nil success:success failure:failure];
}

+ (void)getPeopleWithID:(NSString *)ID
      completionHandler:(LIGetPeopleResponse)completionHandler {
  NSString *path = [NSString stringWithFormat:@"people/id=%@:(positions)",
                                              ID];
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    completionHandler ? completionHandler(JSON, nil) : NULL;
  };
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    NSLog(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
     unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  [httpClient getPath:path parameters:nil success:success failure:failure];
}

+ (void)getPeopleCurrentConnectionsWithCompletionHandler:
    (LIGetPeopleCurrentConnectionsResponse)completionHandler {
  NSString *path = @"people/~/connections:(id)";
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    NSLog(@"LinkedIn: Connections, %@", JSON);
    // TODO(rcacheaux): Add protection against changes in JSON.
    completionHandler ? completionHandler(JSON[@"values"], nil) : NULL;
  };
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    NSLog(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
        unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  NSDictionary *paramters = @{@"start": @"0", @"count": @"10"};
  [httpClient getPath:path parameters:paramters success:success failure:failure];
}

@end
