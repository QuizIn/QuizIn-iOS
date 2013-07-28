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

@implementation LinkedIn

+ (void)getPeopleCurrentUserWithCompletionHandler:(LIGetPeopleResponse)completionHandler {
  NSString *path = @"people/~";
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    DDLogInfo(@"LinkedIn: Profile, %@", JSON);
    completionHandler ? completionHandler(JSON, nil) : NULL;
  };
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
        unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  [httpClient getPath:path parameters:nil success:success failure:failure];
}

+ (void)getPeopleCurrentUserConnectionsCountWithOnSuccess:(void (^)(NSInteger numberOfConnections))onSuccess
                                                onFailure:(void (^)(NSError *error))onFailure {
  NSString *path = @"people/~:(num-connections)";
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    DDLogInfo(@"LinkedIn: Profile, %@", JSON);
    NSInteger numberOfConnections = [JSON[@"numConnections"] intValue];
    onSuccess ? onSuccess(numberOfConnections) : NULL;
  };
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    onFailure ? onFailure(error) : NULL;
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
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
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
     unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  
  [httpClient getPath:path parameters:nil success:success failure:failure];
}

+ (void)getPeopleConnectionsWithCompletionHandler:
    (LIGetPeopleCurrentConnectionsResponse)completionHandler {
  NSString *path = @"people/~/connections:(id)";
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    DDLogInfo(@"LinkedIn: Connections, %@", JSON);
    // TODO(rcacheaux): Add protection against changes in JSON.
    completionHandler ? completionHandler(JSON[@"values"], nil) : NULL;
  };
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
        unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  NSDictionary *paramters = @{@"start": @"0", @"count": @"10"};
  [httpClient getPath:path parameters:paramters success:success failure:failure];
}

+ (void)getPeopleConnectionsWithStartIndex:(NSUInteger)startIndex
                                     count:(NSUInteger)count
                                 onSuccess:(void (^)(QIConnectionsStore *connections))onSuccess
                                 onFailure:(void (^)(NSError *error))onFailure {
  NSString *path = @"people/~/connections:(id,first-name,last-name,positions,location,industry,picture-url)";
  LIHTTPClient *httpClient = [LIHTTPClient sharedClient];
  AFHTTPRequestOperationSuccess success = ^(AFHTTPRequestOperation *requestOperation,
                                            NSDictionary *JSON){
    DDLogInfo(@"LinkedIn: Connections, %@", JSON);
    
    QIConnectionsStore *connections = [QIConnectionsStore new];
    NSMutableArray *people = [NSMutableArray arrayWithCapacity:[JSON[@"_count"] intValue]];
    NSArray *JSONPeople = JSON[@"values"];
    for (NSDictionary *JSONPerson in JSONPeople) {
      QIPerson *person = [QIPerson new];
      person.personID = JSONPerson[@"id"];
      person.firstName = JSONPerson[@"firstName"];
      person.lastName = JSONPerson[@"lastName"];
      person.industry = JSONPerson[@"industry"];
      person.pictureURL = JSONPerson[@"pictureUrl"];
      
      QILocation *location = [QILocation new];
      location.countryCode = JSONPerson[@"location"][@"country"][@"code"];
      location.name = JSONPerson[@"location"][@"name"];
      person.location = location;
      
      // TODO(Rene): Test if JSON has no positions in values.
      NSArray *JSONPositions = JSONPerson[@"positions"][@"values"];
      NSMutableArray *positions =
          [NSMutableArray arrayWithCapacity:[JSONPerson[@"positions"][@"_total"] intValue]];
      for (NSDictionary *JSONPosition in JSONPositions) {
        QIPosition *position = [QIPosition new];
        position.positionID = JSONPosition[@"id"];
        // TODO(Rene): Does JSON bool map to BOOL?
        position.isCurrent = [JSONPosition[@"isCurrent"] boolValue];
        position.title = JSONPosition[@"title"];
        
        NSDateComponents *dateComponents = [NSDateComponents new];
        [dateComponents setMonth:[JSONPosition[@"startDate"][@"month"] intValue]];
        [dateComponents setYear:[JSONPosition[@"startDate"][@"year"] intValue]];
        NSCalendar *gregorianCalendar =
            [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        position.startDate = [gregorianCalendar dateFromComponents:dateComponents];
        
        NSDictionary *JSONCompany = JSONPosition[@"company"];
        QICompany *company = [QICompany new];
        company.companyID = JSONCompany[@"id"];
        company.industry = JSONCompany[@"industry"];
        company.name = JSONCompany[@"name"];
        company.size = JSONCompany[@"size"];
        company.ticker = JSONCompany[@"ticker"];
        company.type = JSONCompany[@"type"];
        position.company = company;
        
        [positions addObject:position];
      }
      person.positions = [positions copy];
    
      [people addObject:person];
    }
    connections.people = [people copy];
    
    onSuccess ? onSuccess(connections) : NULL;
  };
  AFHTTPRequestOperationFailure failure = ^(AFHTTPRequestOperation *requestOperation,
                                            NSError *error){
    
    onFailure ? onFailure(error) : NULL;
    // TODO(Rene): Check for unauth responses globally.
    DDLogInfo(@"LinkedIn: ERROR, HTTP Error: %@, for operation, %@", error,requestOperation);
    [[AKLinkedInAuthController sharedController]
        unauthenticateAccount:[[AKAccountStore sharedStore] authenticatedAccount]];
  };
  NSDictionary *paramters = @{@"start": [NSString stringWithFormat:@"%d", startIndex],
                              @"count": [NSString stringWithFormat:@"%d", count]};
  [httpClient getPath:path parameters:paramters success:success failure:failure];
}

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
    parameters.fieldSelector =
        @"(id,first-name,last-name,formatted-name,positions,location,industry,picture-url,public-profile-url)";
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
