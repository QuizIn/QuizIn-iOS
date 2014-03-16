#import <Foundation/Foundation.h>

@interface QICompany : NSObject<NSCopying>

@property(nonatomic, copy) NSString *companyID;
@property(nonatomic, copy) NSString *industry;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *size;
@property(nonatomic, copy) NSString *ticker;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *websiteURLString;
@property(nonatomic, copy) NSString *logoURLString;
@property(nonatomic, copy) NSString *squareLogoURLString;
@property(nonatomic, copy) NSString *companyDescription;
@property(nonatomic, copy) NSString *foundedYear;
@property(nonatomic, copy) NSString *headquarterLocationDescription;

@end
