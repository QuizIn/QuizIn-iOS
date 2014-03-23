#import "QILIConnections.h"

#import <AuthKit/AKAccountStore.h>

#import "AFNetworkingBlockTypes.h"
#import "AKLinkedInAuthController.h"
#import "LIHTTPClient.h"
#import "QIConnectionsStore+Factory.h"
#import "QIHelpers.h"

@implementation QILIConnectionsParameters
- (id)init {
  self = [super init];
  if (self) {
    _start = -1;
    _count = -1;
  }
  return self;
}

- (NSDictionary *)queryParameterDictionary {
  NSMutableDictionary *queryParameters = [NSMutableDictionary dictionaryWithCapacity:5];
  if (self.start >= 0 && self.count > 0) {
    queryParameters[@"start"] = qi_stringFromInteger(self.start);
    queryParameters[@"count"] = qi_stringFromInteger(self.count);
  }
  if (self.modified != nil && self.modifiedSince != nil) {
    queryParameters[@"modified"] = [self.modified copy];
    queryParameters[@"modified-since"] = [self.modifiedSince copy];
  }
  return [queryParameters copy];
}
@end

@implementation QILIConnections

+ (void)getForAuthenticatedUserWithParameters:(QILIConnectionsParameters *)parameters
                                 onCompletion:(QIConnectionsStoreResult)onCompletion {
  // Completion.
  QIConnectionsJSONResult JSONCompletion = ^(NSArray *connectionsJSON, NSError *error) {
    if (error == nil) {
      QIConnectionsStore *connectionsStore = [QIConnectionsStore storeWithJSON:connectionsJSON];
      onCompletion ? onCompletion(connectionsStore, nil) : NULL;
    } else {
      onCompletion ? onCompletion(nil, error) : NULL;
    }
  };
  
  [self getAsJSONForAuthenticatedUserWithParameters:parameters onCompletion:JSONCompletion];
}

+ (void)getAsJSONForAuthenticatedUserWithParameters:(QILIConnectionsParameters *)parameters
                                       onCompletion:(QIConnectionsJSONResult)onCompletion {
  
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  
  // Construct path.
  NSMutableString *resourcePath = [@"people/~/connections" mutableCopy];
  if (parameters.fieldSelector) {
    [resourcePath appendFormat:@":%@", parameters.fieldSelector];
  }
  
  // Build query parameter dictionary.
  NSDictionary *queryParameters = [parameters queryParameterDictionary];
  
  // Success block.
  AFHTTPRequestOperationSuccess success = ^(NSURLSessionDataTask *task,
                                            NSDictionary *JSON){
    NSArray *connectionsJSON = JSON[@"values"];
    onCompletion ? onCompletion(connectionsJSON, nil) : NULL;
  };
  // Failure block.
  AFHTTPRequestOperationFailure failure = ^(NSURLSessionDataTask *task,
                                            NSError *error){
    onCompletion ? onCompletion(nil, error) : NULL;
    // TODO(Rene): Check for unauth responses globally.
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for task, %@", error, task);
    [[AKLinkedInAuthController sharedController]
        unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };

  [httpClient GET:[resourcePath copy] parameters:queryParameters success:success failure:failure];
}

@end
