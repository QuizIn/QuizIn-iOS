#import <Foundation/Foundation.h>

@interface QISearchFacet : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSArray *buckets;

@end
