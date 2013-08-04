#import "QILISearch.h"

#import <AuthKit/AKAccountStore.h>

#import "AFNetworkingBlockTypes.h"
#import "AKLinkedInAuthController.h"
#import "LIHTTPClient.h"

@implementation QILISearch

+ (void)getPeopleSearchWithFieldSelector:(NSString *)fieldSelector
                        searchParameters:(NSDictionary *)searchParameters
                            onCompletion:(QISearchResult)onCompletion {
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  
  // Construct path.
  NSMutableString *resourcePath = [@"/v1/people-search" mutableCopy];
  if (fieldSelector) {
    [resourcePath appendFormat:@":%@", fieldSelector];
  }
  
  // Build query parameter dictionary.
  NSMutableDictionary *queryParameters = [@{@"secure-urls": @"true"} mutableCopy];
  [queryParameters addEntriesFromDictionary:searchParameters];
  
  // Success block.
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            id JSON){
    
    NSLog(@"%@", JSON);
    onCompletion ? onCompletion(nil, nil) : NULL;
  };
  // Failure block.
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    
    onCompletion ? onCompletion(nil, error) : NULL;
    // TODO(Rene): Check for unauth responses globally.
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
     unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  NSMutableURLRequest *urlRequest = [httpClient requestWithMethod:@"GET"
                                                      path:resourcePath
                                                parameters:searchParameters];
  NSString *urlString = [urlRequest.URL absoluteString];
  urlString = [urlString stringByReplacingOccurrencesOfString:@"IDUPI" withString:@""];
  urlRequest.URL = [NSURL URLWithString:urlString];
  
  AFHTTPRequestOperation *operation = [httpClient HTTPRequestOperationWithRequest:urlRequest
                                                                          success:success
                                                                          failure:failure];
  [httpClient enqueueHTTPRequestOperation:operation];
}

@end
