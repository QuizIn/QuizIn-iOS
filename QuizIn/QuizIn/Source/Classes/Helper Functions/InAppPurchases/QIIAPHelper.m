
#import "QIIAPHelper.h"

@implementation QIIAPHelper

+ (QIIAPHelper *)sharedInstance {
  static dispatch_once_t once;
  static QIIAPHelper * sharedInstance;
  dispatch_once(&once, ^{
    NSSet * productIdentifiers = [NSSet setWithObjects:
                                  @"com.kuhlmanation.hobnob.p_kit",
                                  @"com.kuhlmanation.hobnob.q_pack",
                                  @"com.kuhlmanation.hobnob.f_pack",
                                  @"com.kuhlmanation.hobnob.r_pack",
                                  nil];
    sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
  });
  return sharedInstance;
}

@end
