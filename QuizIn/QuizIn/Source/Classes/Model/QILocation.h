#import <Foundation/Foundation.h>

@interface QILocation : NSObject<NSCopying>

@property(nonatomic, copy) NSString *countryCode;
@property(nonatomic, copy) NSString *name;

@end
