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
#import "QILISearch.h"
#import "QIConnectionsStore+Factory.h"

#import "QILIPagedSearch.h"

typedef void (^AFHTTPRequestOperationSuccess)(AFHTTPRequestOperation *operation,
                                              id responseObject);
typedef void (^AFHTTPRequestOperationFailure)(AFHTTPRequestOperation *operation,
                                              NSError *error);

@implementation LinkedIn

+ (NSString *)peopleFieldSelector {
  return @"id,first-name,last-name,formatted-name,positions,location,industry,picture-url,public-profile-url";
}

+ (void)randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:(NSInteger)numberOfConnectionsToFetch
                                                               onCompletion:(LIConnectionsResponse)onCompletion {
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
                                                         onCompletion:(LIConnectionsResponse)onCompletion {
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
    parameters.fieldSelector = [NSString stringWithFormat:@"(%@)", [self peopleFieldSelector]];
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

+ (void)allFirstDegreeConnectionsForAuthenticatedUserInLocations:(NSArray *)locationCodes
                                                    onCompletion:(LIConnectionsResponse)onCompletion {
  NSString *locationCodeString = [locationCodes componentsJoinedByString:@","];
  NSString *locationFacetString = [NSString stringWithFormat:@"location,%@", locationCodeString];
  
  QILIPagedSearch *pagedSearch = [[QILIPagedSearch alloc] initWithFacetValues:@[locationFacetString]];
  [pagedSearch searchWithOnCompletion:^(NSError *error) {
    if (error == nil) {
      onCompletion? onCompletion(pagedSearch.resultsConnectionsStore, nil) : NULL;
    } else {
      NSLog(@"LinkedIn API Call Error searching for people: %@", error);
      onCompletion? onCompletion(nil, error) : NULL;
    }
  }];
}

+ (void)allFirstDegreeConnectionsForAuthenticatedUserInIndustries:(NSArray *)industryCodes
                                                     onCompletion:(LIConnectionsResponse)onCompletion {
  NSString *industryCodeString = [industryCodes componentsJoinedByString:@","];
  NSString *industryFacetString = [NSString stringWithFormat:@"industry,%@", industryCodeString];
  
  QILIPagedSearch *pagedSearch = [[QILIPagedSearch alloc] initWithFacetValues:@[industryFacetString]];
  [pagedSearch searchWithOnCompletion:^(NSError *error) {
    if (error == nil) {
      onCompletion? onCompletion(pagedSearch.resultsConnectionsStore, nil) : NULL;
    } else {
      DDLogError(@"LinkedIn API Call Error searching for people: %@", error);
      onCompletion? onCompletion(nil, error) : NULL;
    }
  }];
}

+ (void)allFirstDegreeConnectionsForAuthenticatedUserInSchools:(NSArray *)schoolCodes
                                                  onCompletion:(LIConnectionsResponse)onCompletion {
  NSString *schoolCodeString = [schoolCodes componentsJoinedByString:@","];
  NSString *schoolFacetString = [NSString stringWithFormat:@"school,%@", schoolCodeString];
  
  QILIPagedSearch *pagedSearch = [[QILIPagedSearch alloc] initWithFacetValues:@[schoolFacetString]];
  [pagedSearch searchWithOnCompletion:^(NSError *error) {
    if (error == nil) {
      onCompletion? onCompletion(pagedSearch.resultsConnectionsStore, nil) : NULL;
    } else {
      DDLogError(@"LinkedIn API Call Error searching for people: %@", error);
      onCompletion? onCompletion(nil, error) : NULL;
    }
  }];
}

+ (void)allFirstDegreeConnectionsForAuthenticatedUserInCurrentCompanies:(NSArray *)companyCodes
                                                           onCompletion:(LIConnectionsResponse)onCompletion {
  NSString *companyCodeString = [companyCodes componentsJoinedByString:@","];
  NSString *currentCompanyFacetString = [NSString stringWithFormat:@"current-company,%@", companyCodeString];
  
  QILIPagedSearch *pagedSearch = [[QILIPagedSearch alloc] initWithFacetValues:@[currentCompanyFacetString]];
  [pagedSearch searchWithOnCompletion:^(NSError *error) {
    if (error == nil) {
      onCompletion? onCompletion(pagedSearch.resultsConnectionsStore, nil) : NULL;
    } else {
      DDLogError(@"LinkedIn API Call Error searching for people: %@", error);
      onCompletion? onCompletion(nil, error) : NULL;
    }
  }];
}

@end
