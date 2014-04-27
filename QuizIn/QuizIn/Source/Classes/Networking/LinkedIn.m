#import "LinkedIn.h"

#import <AuthKit/AKAccountStore.h>

#import "LIHTTPClient.h"
#import "AKLinkedInAuthController.h"

#import "AFNetworkingBlockTypes.h"

#import "QIConnectionsStore.h"
#import "QIPerson.h"
#import "QILocation.h"
#import "QIPosition.h"
#import "QICompany.h"
#import "QIIndustry.h"
#import "QISchool.h"
#import "QISearchFacet.h"
#import "QISearchFacetBucket.h"
#import "QILICompanies.h"

#import "QILIPeople.h"
#import "QILIConnections.h"
#import "QILISearch.h"
#import "QIConnectionsStore+Factory.h"


#import <AuthKit/AKAccountStore.h>

#import "QILIPagedSearch.h"

static QIPerson *authenticatedUser;

@implementation LinkedIn

+ (QIPerson *)authenticatedUser {
 
  //todo rkuhlman offline/online
  /*
  //offline
  QIPerson *person = [[QIPerson alloc] init];
  person.personID = @"12345";
  person.firstName = @"Test";
  person.lastName = @"User";
  person.formattedName = @"Test User";
  person.industry = @"Test Industry";
  person.pictureURL = @"";
  person.location = nil;
  person.positions = @[@"Test Position 0",@"Test Position 1"];
  person.numberOfConnections = 269;
  person.publicProfileURL = @"http://www.google.com";
  return person;
  */
  //online
  return [authenticatedUser copy];
}

+ (void)updateAuthenticatedUserWithOnCompletion:(LIAuthenticatedUserResponse)onCompletion {
  AKAccountStore *store = [AKAccountStore sharedStore];
  if ([store authenticatedAccount]) {
    [QILIPeople
     getProfileForAuthenticatedUserWithFieldSelector:[self peopleFieldSelector]
     onCompletion:^(QIPerson *person, NSError *error) {
        if (!error) {
          authenticatedUser = [person copy];
        }
        onCompletion? onCompletion(authenticatedUser, error) : NULL;
    }];
  } else {
    authenticatedUser = nil;
    onCompletion? onCompletion(nil, nil) : NULL;
  }
}

+ (NSString *)peopleFieldSelector {
  return @"id,first-name,last-name,formatted-name,positions,location,industry,picture-url,public-profile-url";
}

+ (NSString *)companyFieldSelector {
  return @"id,name,industries,employee-count-range,ticker,company-type,website-url,logo-url,square-logo-url,locations:(is-headquarters,address),description,founded-year";
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
    DDLogWarn(@"User's number of connections: %d is less than requested for batched connections: %ld.",
               numberOfConnections, (long)numberOfConnectionsToFetch);
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
  
  [QILIPeople getProfileForAuthenticatedUserWithFieldSelector:@"num-connections"
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

// TODO: Consolidate the following four methods, they contain the same logic.
+ (void)topFirstDegreeConnectionCompaniesForAuthentedUserWithOnCompletion:(LICompaniesResponse)onCompletion {
  [QILISearch
   getPeopleSearchFacets:@[@"current-company"]
   withSearchParameters:@{@"facet": @"network,F"}
   onCompletion:^(NSArray *facets, NSError *error) {
     if (!error) {
       NSArray *companyNames = @[];
       for (QISearchFacet *facet in facets) {
         if ([facet.code isEqualToString:@"current-company"]) {
           NSMutableArray *companies = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
           for (QISearchFacetBucket *bucket in facet.buckets) {
             QICompany *company = [QICompany new];
             company.companyID = bucket.code;
             company.name = bucket.name;
             [companies addObject:company];
           }
           companyNames = [companies copy];
         }
       }
       onCompletion? onCompletion(companyNames, nil) : NULL;
     } else {
       onCompletion? onCompletion(nil, error) : NULL;
     }
   }];
}

+ (void)topFirstDegreeConnectionIndustriesForAuthenticatedUserWithOnCompletion:(LIIndustriesResponse)onCompletion {
  [QILISearch
   getPeopleSearchFacets:@[@"industry"]
   withSearchParameters:@{@"facet": @"network,F"}
   onCompletion:^(NSArray *facets, NSError *error) {
     if (!error) {
       NSArray *industries = @[];
       for (QISearchFacet *facet in facets) {
         if ([facet.code isEqualToString:@"industry"]) {
           NSMutableArray *mutableIndustries = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
           for (QISearchFacetBucket *bucket in facet.buckets) {
             QIIndustry *industry = [QIIndustry new];
             industry.code = bucket.code;
             industry.name = bucket.name;
             [mutableIndustries addObject:industry];
           }
           industries = [mutableIndustries copy];
         }
       }
       onCompletion? onCompletion(industries, nil) : NULL;
     } else {
       onCompletion? onCompletion(nil, error) : NULL;
     }
  }];
}

+ (void)topFirstDegreeConnectionLocationsForAuthenticatedUserWithOnCompletion:(LILocationsResponse)onCompletion {
  [QILISearch
   getPeopleSearchFacets:@[@"location"]
   withSearchParameters:@{@"facet": @"network, F"}
   onCompletion:^(NSArray *facets, NSError *error) {
     if (!error) {
       NSArray *locations = @[];
       for (QISearchFacet *facet in facets) {
         if ([facet.code isEqualToString:@"location"]) {
           NSMutableArray *mutableLocations = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
           for (QISearchFacetBucket *bucket in facet.buckets) {
             QILocation *location = [QILocation new];
             location.countryCode = bucket.code;
             location.name = bucket.name;
             [mutableLocations addObject:location];
           }
           locations = [mutableLocations copy];
         }
       }
       onCompletion? onCompletion(locations, nil) : NULL;
     } else {
       onCompletion? onCompletion(nil, error) : NULL;
     }
   }];
}

+ (void)topFirstDegreeConnectionSchoolsForAuthenticatedUserWithOnCompletion:(LISchoolsResponse)onCompletion {
  [QILISearch
   getPeopleSearchFacets:@[@"school"]
   withSearchParameters:@{@"facet": @"network,F"}
   onCompletion:^(NSArray *facets, NSError *error) {
     if (!error) {
       NSArray *schools = @[];
       for (QISearchFacet *facet in facets) {
         if ([facet.code isEqualToString:@"school"]) {
           NSMutableArray *mutableSchools = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
           for (QISearchFacetBucket *bucket in facet.buckets) {
             QISchool *school = [QISchool new];
             school.code = bucket.code;
             school.name = bucket.name;
             [mutableSchools addObject:school];
           }
           schools = [mutableSchools copy];
         }
       }
       onCompletion? onCompletion(schools, nil) : NULL;
     } else {
       onCompletion? onCompletion(nil, error) : NULL;
     }

  }];
}

+ (void)searchForCompaniesWithName:(NSString *)companyName withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LICompaniesResponse)onCompletion {
  [QILISearch
   getPeopleSearchFacets:@[@"current-company"]
   withSearchParameters:@{@"facet": @"network,F",
                          @"company-name": companyName}
   onCompletion:^(NSArray *facets, NSError *error) {
     if (!error) {
       NSArray *companyNames = @[];
       for (QISearchFacet *facet in facets) {
         if ([facet.code isEqualToString:@"current-company"]) {
           NSMutableArray *companies = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
           for (QISearchFacetBucket *bucket in facet.buckets) {
             QICompany *company = [QICompany new];
             company.companyID = bucket.code;
             company.name = bucket.name;
             [companies addObject:company];
           }
           companyNames = [companies copy];
         }
       }
       onCompletion? onCompletion(companyNames, nil) : NULL;
     } else {
       onCompletion? onCompletion(nil, error) : NULL;
     }
   }];
}

+ (void)searchForIndustryWithKeyword:(NSString *)industryKeyword withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LIIndustriesResponse)onCompletion {
    [QILISearch
     getPeopleSearchFacets:@[@"industry"]
     withSearchParameters:@{@"facet": @"network,F",
                            @"keywords": industryKeyword}
     onCompletion:^(NSArray *facets, NSError *error) {
         if (!error) {
             NSArray *industryNames = @[];
             for (QISearchFacet *facet in facets) {
                 if ([facet.code isEqualToString:@"industry"]) {
                     NSMutableArray *industries = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
                     for (QISearchFacetBucket *bucket in facet.buckets) {
                         QIIndustry *industry = [QIIndustry new];
                         industry.code = bucket.code;
                         industry.name = bucket.name;
                         [industries addObject:industry];
                     }
                     industryNames = [industries copy];
                 }
             }
             onCompletion? onCompletion(industryNames, nil) : NULL;
         } else {
             onCompletion? onCompletion(nil, error) : NULL;
         }
     }];
}

+ (void)searchForSchoolsWithName:(NSString *)schoolName withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LISchoolsResponse)onCompletion {
  [QILISearch
   getPeopleSearchFacets:@[@"school"]
   withSearchParameters:@{@"facet": @"network,F",
                          @"school-name": schoolName}
   onCompletion:^(NSArray *facets, NSError *error) {
     if (!error) {
       NSArray *schoolNames = @[];
       for (QISearchFacet *facet in facets) {
         if ([facet.code isEqualToString:@"school"]) {
           NSMutableArray *schools = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
           for (QISearchFacetBucket *bucket in facet.buckets) {
             QISchool *school = [QISchool new];
             school.code = bucket.code;
             school.name = bucket.name;
             [schools addObject:school];
           }
           schoolNames = [schools copy];
         }
       }
       onCompletion? onCompletion(schoolNames, nil) : NULL;
     } else {
       onCompletion? onCompletion(nil, error) : NULL;
     }
   }];
}


+ (void)searchForLocationsWithKeywords:(NSString *)locationName withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LILocationsResponse)onCompletion {
  [QILISearch
   getPeopleSearchFacets:@[@"location"]
   withSearchParameters:@{@"facet": @"network,F",
                          @"keywords": locationName}
   onCompletion:^(NSArray *facets, NSError *error) {
     if (!error) {
       NSArray *locationNames = @[];
       for (QISearchFacet *facet in facets) {
         if ([facet.code isEqualToString:@"location"]) {
           NSMutableArray *locations = [NSMutableArray arrayWithCapacity:[facet.buckets count]];
           for (QISearchFacetBucket *bucket in facet.buckets) {
             QILocation *location = [QILocation new];
             location.countryCode = bucket.code;
             location.name = bucket.name;
             [locations addObject:location];
           }
           locationNames = [locations copy];
         }
       }
       onCompletion? onCompletion(locationNames, nil) : NULL;
     } else {
       onCompletion? onCompletion(nil, error) : NULL;
     }
   }];
}


+ (void)peopleWithIDs:(NSArray *)personIDs onCompletion:(LIGetPeopleResponse)onCompletion {
  NSInteger numberOfPeople = [personIDs count];
  __block NSInteger returnCount = 0;
  __block NSMutableArray *people = [NSMutableArray arrayWithCapacity:numberOfPeople];
  __block NSError *profileFetchError = nil;
  for (NSString *personID in personIDs) {
    [QILIPeople
     getProfileForPersonWithID:personID
     withFieldSelector:[self peopleFieldSelector]
     onCompletion:^(QIPerson *person, NSError *error) {
       returnCount++;
       if (person) {
         [people addObject:person];
       }
       if (error) {
         profileFetchError = error;
       }
       if (returnCount >= numberOfPeople) {
         onCompletion([people copy], profileFetchError);
       }
     }];
  }
}

+ (void)companiesWithIDs:(NSArray *)companyIDs onCompletion:(LICompaniesResponse)onCompletion {
  [QILICompanies
   getCompaniesWithIDs:companyIDs
   fieldSelector:[self companyFieldSelector]
   onCompletion:^(NSArray *companies, NSError *error) {
     onCompletion ? onCompletion(companies, error) : NULL;
   }];
}

@end
