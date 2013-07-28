#import "QILIPeople.h"

#import <AuthKit/AKAccountStore.h>

#import "AFNetworkingBlockTypes.h"
#import "AKLinkedInAuthController.h"
#import "LIHTTPClient.h"
#import "QIPerson+Factory.h"

@implementation QILIPeople

+ (void)getProfileForAuthenticatedUserWithFieldSelector:(NSString *)fieldSelector
                                           onCompletion:(QIProfileResult)onCompletion {
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  
  // Construct path.
  NSMutableString *resourcePath = [@"people/~" mutableCopy];
  if (fieldSelector) {
    [resourcePath appendFormat:@":%@", fieldSelector];
  }
  
  // Build query parameter dictionary.
  NSDictionary *queryParameters = @{@"secure-urls": @"true"};
  
  // Success block.
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    
    QIPerson *person = [QIPerson personWithJSON:JSON];
    onCompletion ? onCompletion(person, nil) : NULL;
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

  [httpClient getPath:[resourcePath copy]
           parameters:queryParameters
              success:success
              failure:failure];
}

@end
