
#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

@interface QIStoreData : NSObject

+ (NSArray *)getStoreDataWithProducts:(NSArray *)products;
+ (NSArray *)getBuyAllProductWithProducts:(NSArray *)products;
+ (NSDictionary *)storeItemWithProduct:(SKProduct *)product;


@end
