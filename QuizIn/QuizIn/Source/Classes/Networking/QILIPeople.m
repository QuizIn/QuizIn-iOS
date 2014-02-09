#import "QILIPeople.h"

#import <AuthKit/AKAccountStore.h>

#import "AFNetworkingBlockTypes.h"
#import "AKLinkedInAuthController.h"
#import "LIHTTPClient.h"
#import "QIPerson+Factory.h"

@implementation QILIPeople

+ (void)getProfileForAuthenticatedUserWithFieldSelector:(NSString *)fieldSelector
                                           onCompletion:(QIProfileResult)onCompletion {
  // Construct path.
  NSMutableString *resourcePath = [@"people/~" mutableCopy];
  [self getProfileWithResourcePath:resourcePath fieldSelector:fieldSelector onCompletion:onCompletion];
}

+ (void)getProfileForPersonWithID:(NSString *)personID
                withFieldSelector:(NSString *)fieldSelector
                     onCompletion:(QIProfileResult)onCompletion {
  // Construct path.
  NSMutableString *resourcePath = [[NSString stringWithFormat:@"people/id=%@", personID] mutableCopy];
  [self getProfileWithResourcePath:resourcePath fieldSelector:fieldSelector onCompletion:onCompletion];
}

+ (void)getProfileWithResourcePath:(NSMutableString *)resourcePath
                     fieldSelector:(NSString *)fieldSelector
                      onCompletion:(QIProfileResult)onCompletion {
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  
  // Construct path.
  if (fieldSelector) {
    [resourcePath appendFormat:@":(%@)", fieldSelector];
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
