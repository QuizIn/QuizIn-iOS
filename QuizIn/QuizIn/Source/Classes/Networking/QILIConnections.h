#import <Foundation/Foundation.h>

@class QIConnectionsStore;

typedef void (^QIConnectionsStoreResult)(QIConnectionsStore *connectionsStore, NSError *error);
typedef void (^QIConnectionsJSONResult)(NSArray *connectionsJSON, NSError *error);

@interface QILIConnectionsParameters : NSObject
@property(nonatomic, assign) NSInteger start;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy) NSString *modified;
@property(nonatomic, copy) NSDate *modifiedSince;
@property(nonatomic, copy) NSString *fieldSelector;

- (NSDictionary *)queryParameterDictionary;
@end

@interface QILIConnections : NSObject

+ (void)getForAuthenticatedUserWithParameters:(QILIConnectionsParameters *)parameters
                                 onCompletion:(QIConnectionsStoreResult)onCompletion;

+ (void)getAsJSONForAuthenticatedUserWithParameters:(QILIConnectionsParameters *)parameters
                                       onCompletion:(QIConnectionsJSONResult)onCompletion;

@end
