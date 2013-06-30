#import <Foundation/Foundation.h>

@interface QICompany : NSObject<NSCopying>

@property(nonatomic, copy) NSString *companyID;
@property(nonatomic, copy) NSString *industry;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *size;
@property(nonatomic, copy) NSString *ticker;
@property(nonatomic, copy) NSString *type;

@end
