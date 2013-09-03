
#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

@interface QIStoreData : NSObject

+ (NSArray *) getStoreData;
+ (NSArray *) getStoreDataWithProducts:(NSArray *)products;

@end
