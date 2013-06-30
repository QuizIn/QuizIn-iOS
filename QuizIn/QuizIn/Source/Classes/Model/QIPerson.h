#import <Foundation/Foundation.h>

@class QILocation;

@interface QIPerson : NSObject

@property(nonatomic, copy) NSString *personID;
@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, copy) NSString *industry;
@property(nonatomic, copy) QILocation *location;
@property(nonatomic, copy) NSArray *positions;

@end
