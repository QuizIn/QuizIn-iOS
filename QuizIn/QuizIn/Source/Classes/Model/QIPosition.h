#import <Foundation/Foundation.h>

@class QICompany;

@interface QIPosition : NSObject<NSCopying>

@property(nonatomic, copy) NSString *positionID;
@property(nonatomic, copy) QICompany *company;
@property(nonatomic, assign) BOOL isCurrent;
@property(nonatomic, copy) NSDate *startDate;
@property(nonatomic, copy) NSString *title;

@end
