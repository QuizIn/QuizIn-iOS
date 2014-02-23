#import "QILIPeople.h"

#import <AuthKit/AKAccountStore.h>

#import "AFNetworkingBlockTypes.h"
#import "AKLinkedInAuthController.h"
#import "LIHTTPClient.h"
#import "QIPerson+Factory.h"
#import "QIConnectionsStore.h"
#import "QIPerson.h"
#import "QIPerson+Factory.h"
#import "QILocation.h"
#import "QILocation+Factory.h"
#import "QIPosition.h"
#import "QIPosition+Factory.h"
#import "QICompany.h"
#import "QICompany+Factory.h"

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
                                            NSDictionary *personJSON){
    
    QIPerson *person = [QIPerson personWithJSON:personJSON];
    QILocation *location = [QILocation locationWithJSON:personJSON[@"location"]];
    person.location = location;
    
    // TODO(Rene): Test if JSON has no positions in values.
    NSArray *positionsJSON = personJSON[@"positions"][@"values"];
    NSMutableSet *positions =
    [NSMutableSet setWithCapacity:[personJSON[@"positions"][@"_total"] intValue]];
    for (NSDictionary *positionJSON in positionsJSON) {
      QIPosition *position = [QIPosition positionWithJSON:positionJSON];
      NSDictionary *companyJSON = positionJSON[@"company"];
      QICompany *company = [QICompany companyWithJSON:companyJSON];
      position.company = company;
      [positions addObject:position];
    }
    person.positions = [positions copy];
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
