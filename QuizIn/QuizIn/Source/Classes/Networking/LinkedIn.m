#import "LinkedIn.h"

#import <AuthKit/AKAccountStore.h>

#import "LIHTTPClient.h"
#import "AKLinkedInAuthController.h"

#import "QIConnectionsStore.h"
#import "QIPerson.h"
#import "QILocation.h"
#import "QIPosition.h"
#import "QICompany.h"

#import "QILIPeople.h"
#import "QILIConnections.h"
#import "QIConnectionsStore+Factory.h"


typedef void (^AFHTTPRequestOperationSuccess)(AFHTTPRequestOperation *operation,
                                              id responseObject);
typedef void (^AFHTTPRequestOperationFailure)(AFHTTPRequestOperation *operation,
                                              NSError *error);

NSString * const kPeopleFieldSelector =
    @"id,first-name,last-name,formatted-name,positions,location,industry,picture-url,public-profile-url";

@implementation LinkedIn

+ (void)randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:(NSInteger)numberOfConnectionsToFetch
                                                               onCompletion:(LIRandomConnectionsResponse)onCompletion {
  if (numberOfConnectionsToFetch <= 0) {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSError *error = [NSError errorWithDomain:@"com.quizin" code:-1 userInfo:nil];
      onCompletion ? onCompletion(nil, error) : NULL;
    });
    return;
  }
  // Number of connections completion.
  LIConnectionsCountResult countCompletion = ^(NSInteger numberOfConnections, NSError *error) {
    NSInteger maxNumberOfConnectionsToFetch = MIN(numberOfConnections, numberOfConnectionsToFetch);
    if (numberOfConnectionsToFetch >  numberOfConnections) {
      DDLogWarn(@"User's number of connections: %d is less than requested for random connections: %d.",
                numberOfConnections, numberOfConnectionsToFetch);
    }
    
    [self batchedConnectionsForAuthenticatedUserWithNumberOfConnections:numberOfConnections
                                             numberOfConnectionsToFetch:maxNumberOfConnectionsToFetch
                                                           maxBatchSize:10
                                                           onCompletion:onCompletion];
  };
  
  // Send request.
  [self numberOfConnectionsForAuthenticatedUserOnCompletion:countCompletion];
}

+ (void)batchedConnectionsForAuthenticatedUserWithNumberOfConnections:(NSInteger)numberOfConnections
                                           numberOfConnectionsToFetch:(NSInteger)numberOfConnectionsToFetch
                                                         maxBatchSize:(NSInteger)maxBatchSize
                                                         onCompletion:(LIRandomConnectionsResponse)onCompletion {
  if (numberOfConnectionsToFetch > numberOfConnections) {
    DDLogWarn(@"User's number of connections: %d is less than requested for batched connections: %d.",
               numberOfConnections, numberOfConnectionsToFetch);
    numberOfConnectionsToFetch = numberOfConnections;
  }
  
  // Build batches.
  NSMutableArray *batches = [NSMutableArray array];
  for (NSInteger i = 0 ; i < numberOfConnectionsToFetch; i += maxBatchSize) {
    NSInteger batchSize = MIN(maxBatchSize, numberOfConnectionsToFetch - i);
    NSInteger randomStartIndex = arc4random_uniform(numberOfConnections - batchSize);
    [batches addObject:@{@"start": @(randomStartIndex), @"size": @(batchSize)}];
  }
  
  // Make the calls.
  NSMutableArray *connections = [NSMutableArray arrayWithCapacity:numberOfConnectionsToFetch];
  __block NSInteger resultCount = 0;
  __block NSError *JSONRequestError = nil;
  for (NSDictionary *batch in batches) {
    QILIConnectionsParameters *parameters = [QILIConnectionsParameters new];
    parameters.start = [batch[@"start"] integerValue];
    parameters.count = [batch[@"size"] integerValue];
    parameters.fieldSelector = [NSString stringWithFormat:@"(%@)", kPeopleFieldSelector];
    // Completion.
    QIConnectionsJSONResult JSONCompletion = ^(NSArray *connectionsJSON, NSError *error) {
      resultCount++;
      if (error == nil) [connections addObjectsFromArray:connectionsJSON];
      else JSONRequestError = error;
      // Check for End.
      if (resultCount == [batches count]) {
        QIConnectionsStore *connectionsStore = [QIConnectionsStore storeWithJSON:[connections copy]];
        onCompletion ? onCompletion(connectionsStore, JSONRequestError) : NULL;
      }
    };
    // Get JSON.
    [QILIConnections getAsJSONForAuthenticatedUserWithParameters:parameters
                                                    onCompletion:JSONCompletion];
  }
}

+ (void)numberOfConnectionsForAuthenticatedUserOnCompletion:(LIConnectionsCountResult)onCompletion {
  // Completion.
  QIProfileResult profileOnCompletion = ^(QIPerson *person, NSError *error) {
    if (person != nil && person.numberOfConnections >= 0) {
      onCompletion ? onCompletion(person.numberOfConnections, nil) : NULL;
    } else {
      NSError *error = [NSError errorWithDomain:@"com.quizin" code:-2 userInfo:nil];
      onCompletion ? onCompletion(-1, error) : NULL;
    }
  };
  
  [QILIPeople getProfileForAuthenticatedUserWithFieldSelector:@"(num-connections)"
                                                 onCompletion:profileOnCompletion];
}

@end
