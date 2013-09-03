
#import "QIIAPHelper.h"

@implementation QIIAPHelper

+ (QIIAPHelper *)sharedInstance {
  static dispatch_once_t once;
  static QIIAPHelper * sharedInstance;
  dispatch_once(&once, ^{
    NSSet * productIdentifiers = [NSSet setWithObjects:
                                  @"com.kuhlmanation.hobnob.d_pack1",
                                  @"com.kuhlmanation.hobnob.p_kit",
                                  @"com.kuhlmanation.hobnob.q_businesscard",
                                  @"com.kuhlmanation.hobnob.q_matching",
                                  @"com.kuhlmanation.hobnob.f_company",
                                  @"com.kuhlmanation.hobnob.f_group",
                                  @"com.kuhlmanation.hobnob.f_industry",
                                  @"com.kuhlmanation.hobnob.f_least",
                                  @"com.kuhlmanation.hobnob.f_locale",
                                  nil];
    sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
  });
  return sharedInstance;
}

@end
