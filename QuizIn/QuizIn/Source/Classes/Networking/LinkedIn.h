#import <Foundation/Foundation.h>

@class QIConnectionsStore;
@class QIPerson;

typedef void (^LIGetPersonResponse)(NSDictionary *profile, NSError *error);
typedef void (^LIGetPeopleCurrentConnectionsResponse)(NSArray *connections,
                                                      NSError *error);
typedef void (^LIConnectionsResponse)(QIConnectionsStore *connectionsStore, NSError *error);
typedef void (^LIConnectionsCountResult)(NSInteger numberOfConnections, NSError *error);
typedef void (^LICompaniesResponse)(NSArray *companies, NSError *error);
typedef void (^LIIndustriesResponse)(NSArray *industries, NSError *error);
typedef void (^LILocationsResponse)(NSArray *locations, NSError *error);
typedef void (^LISchoolsResponse)(NSArray *schools, NSError *error);
typedef void (^LIAuthenticatedUserResponse)(QIPerson *authenticatedUser, NSError *error);
typedef void (^LIGetPeopleResponse)(NSArray *people, NSError *error);

@interface LinkedIn : NSObject

+ (QIPerson *)authenticatedUser;

+ (void)updateAuthenticatedUserWithOnCompletion:(LIAuthenticatedUserResponse)onCompletion;

+ (NSString *)peopleFieldSelector;

+ (void)randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:(NSInteger)numberOfConnectionsToFetch
                                                               onCompletion:(LIConnectionsResponse)onCompletion;

+ (void)numberOfConnectionsForAuthenticatedUserOnCompletion:(LIConnectionsCountResult)onCompletion;

// TODO:Consolidate the following methods into one.
+ (void)allFirstDegreeConnectionsForAuthenticatedUserInLocations:(NSArray *)locationCodes
                                                    onCompletion:(LIConnectionsResponse)onCompletion;
+ (void)allFirstDegreeConnectionsForAuthenticatedUserInIndustries:(NSArray *)industryCodes
                                                     onCompletion:(LIConnectionsResponse)onCompletion;
+ (void)allFirstDegreeConnectionsForAuthenticatedUserInCurrentCompanies:(NSArray *)companyCodes
                                                           onCompletion:(LIConnectionsResponse)onCompletion;
+ (void)allFirstDegreeConnectionsForAuthenticatedUserInSchools:(NSArray *)schoolCodes
                                                  onCompletion:(LIConnectionsResponse)onCompletion;

+ (void)topFirstDegreeConnectionCompaniesForAuthentedUserWithOnCompletion:(LICompaniesResponse)onCompletion;

+ (void)topFirstDegreeConnectionIndustriesForAuthenticatedUserWithOnCompletion:(LIIndustriesResponse)onCompletion;

+ (void)topFirstDegreeConnectionLocationsForAuthenticatedUserWithOnCompletion:(LILocationsResponse)onCompletion;

+ (void)topFirstDegreeConnectionSchoolsForAuthenticatedUserWithOnCompletion:(LISchoolsResponse)onCompletion;

+ (void)searchForCompaniesWithName:(NSString *)companyName withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LICompaniesResponse)onCompletion;

+ (void)searchForIndustryWithKeyword:(NSString *)industryKeyword withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LIIndustriesResponse)onCompletion;

+ (void)searchForSchoolsWithName:(NSString *)schoolName withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LISchoolsResponse)onCompletion;

+ (void)searchForLocationsWithKeywords:(NSString *)locationName withinFirstDegreeConnectionsForAuthenticatedUserWithOnCompletion:(LILocationsResponse)onCompletion;

+ (void)peopleWithIDs:(NSArray *)personIDs onCompletion:(LIGetPeopleResponse)onCompletion;

+ (void)companiesWithIDs:(NSArray *)companyIDs onCompletion:(LICompaniesResponse)onCompletion;


@end
