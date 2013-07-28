#import <Foundation/Foundation.h>

@interface QIConnectionsStore : NSObject

@property(nonatomic, copy) NSDictionary *people;
@property(nonatomic, copy) NSSet *companyNames;
@property(nonatomic, copy) NSSet *industries;
@property(nonatomic, copy) NSSet *personNames;
@property(nonatomic, copy) NSSet *titleNames;
@property(nonatomic, copy) NSSet *cityNames;
@property(nonatomic, copy) NSSet *personIDsWithProfilePics;

@end
