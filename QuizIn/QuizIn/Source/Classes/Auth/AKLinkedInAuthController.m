#import "AKLinkedInAuthController.h"

@implementation AKLinkedInAuthController

- (NSString *)clientID {
  return @"hrsfw0wa1l0x";
}

- (NSString *)accessTokenURLString {
  return @"https://www.linkedin.com/uas/oauth2/accessToken";
}

- (NSString *)serviceName {
  return @"LinkedIn";
}

- (NSString *)redirectURIString {
  return @"http://www.linkedin.com/blah";
}

- (NSString *)clientSecret {
  return @"qbQ3Tr8zHe0vK8ot";
}

- (NSString *)keychainItemName {
  return @"Quizin: Linked In";
}

- (NSString *)scope {
  return @"r_fullprofile r_network";
}

- (NSString *)authCodeURLString {
  return @"https://www.linkedin.com/uas/oauth2/authorization";
}

@end
