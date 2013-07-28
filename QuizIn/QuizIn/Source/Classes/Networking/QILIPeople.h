#import <Foundation/Foundation.h>

@class QIPerson;

typedef void (^QIProfileResult)(QIPerson *person, NSError *error);

@interface QILIPeople : NSObject

+ (void)getProfileForAuthenticatedUserWithFieldSelector:(NSString *)fieldSelector
                                           onCompletion:(QIProfileResult)onCompletion;

@end
