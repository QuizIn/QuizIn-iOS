#import <Foundation/Foundation.h>

@class QIConnectionsStore;

typedef void (^LIGetPeopleResponse)(NSDictionary *profile, NSError *error);
typedef void (^LIGetPeopleCurrentConnectionsResponse)(NSArray *connections,
                                                      NSError *error);
typedef void (^LIConnectionsResponse)(QIConnectionsStore *connectionsStore, NSError *error);
typedef void (^LIConnectionsCountResult)(NSInteger numberOfConnections, NSError *error);

@interface LinkedIn : NSObject

+ (NSString *)peopleFieldSelector;

+ (void)randomConnectionsForAuthenticatedUserWithNumberOfConnectionsToFetch:(NSInteger)numberOfConnectionsToFetch
                                                               onCompletion:(LIConnectionsResponse)onCompletion;

+ (void)numberOfConnectionsForAuthenticatedUserOnCompletion:(LIConnectionsCountResult)onCompletion;

+ (void)allFirstDegreeConnectionsForAuthenticatedUserInLocations:(NSArray *)locationCodes
                                                    onCompletion:(LIConnectionsResponse)onCompletion;
+ (void)allFirstDegreeConnectionsForAuthenticatedUserInIndustries:(NSArray *)industryCodes
                                                     onCompletion:(LIConnectionsResponse)onCompletion;
@end
