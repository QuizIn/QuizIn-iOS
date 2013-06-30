#import <Foundation/Foundation.h>

@class QILocation;

@interface QIPerson : NSObject<NSCopying>

@property(nonatomic, copy) NSString *personID;
@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, copy) NSString *industry;
@property(nonatomic, copy) NSString *pictureURL;
@property(nonatomic, copy) QILocation *location;
@property(nonatomic, copy) NSArray *positions;

@end
