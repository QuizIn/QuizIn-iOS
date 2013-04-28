#import "AKGTMOAuth2Account.h"

#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>

#import "AKOAuth2AccountCredential.h"
#import "AKGTMOAuth2AuthController.h"
#import "AKLinkedInAuthController.h"

@implementation AKGTMOAuth2Account

- (AKOAuth2AccountCredential *)OAuth2Credential {
  // Get credential from Google's GTMOAuth2 library.
  
  AKGTMOAuth2AuthController *authController =
      [AKGTMOAuth2AuthController sharedController];
  GTMOAuth2Authentication *auth = [authController newGTMOAuth2Authentication];
  if (!auth) {
    return nil;
  }
  
  BOOL isAuthenticated =
      [GTMOAuth2ViewControllerTouch
          authorizeFromKeychainForName:authController.keychainItemName
                        authentication:auth];
  if (!isAuthenticated) {
    return nil;
  }

  AKOAuth2AccountCredential *credential = [[AKOAuth2AccountCredential alloc] init];
  credential.accessToken = auth.accessToken;
  return credential;
}

- (void)clearCredential {
  AKGTMOAuth2AuthController *authController =
      [AKGTMOAuth2AuthController sharedController];
  [GTMOAuth2ViewControllerTouch
   removeAuthFromKeychainForName:authController.keychainItemName];
}

- (BOOL)isAuthenticated {
  // TODO(rcacheaux): Clean up. AK stuff is mixed in with QI stuff, need a cleaner line.
  AKGTMOAuth2AuthController *authController =
      [AKLinkedInAuthController sharedController];
  GTMOAuth2Authentication *auth = [authController newGTMOAuth2Authentication];
  if (!auth) {
    return NO;
  }
  
  return
      [GTMOAuth2ViewControllerTouch
          authorizeFromKeychainForName:authController.keychainItemName
                        authentication:auth];
}

@end
