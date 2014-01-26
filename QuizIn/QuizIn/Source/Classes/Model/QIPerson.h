#import <Foundation/Foundation.h>

@class QILocation;
@class QIPosition;

@interface QIPerson : NSObject<NSCopying>

@property(nonatomic, copy) NSString *personID;
@property(nonatomic, copy) NSString *firstName;
@property(nonatomic, copy) NSString *lastName;
@property(nonatomic, copy) NSString *formattedName;
@property(nonatomic, copy) NSString *industry;
@property(nonatomic, copy) NSString *pictureURL;
@property(nonatomic, copy) QILocation *location;
@property(nonatomic, copy) NSArray *positions;
@property(nonatomic, copy, readonly) QIPosition *currentPosition;
@property(nonatomic, assign) NSInteger numberOfConnections;
@property(nonatomic, copy) NSString *publicProfileURL;

@end
