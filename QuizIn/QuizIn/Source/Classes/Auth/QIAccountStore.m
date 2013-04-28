#import "QIAccountStore.h"

#import "AKGTMOAuth2Account.h"

@implementation QIAccountStore

- (Class)accountTypeClass {
  return [AKGTMOAuth2Account class];
}

@end
