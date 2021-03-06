#import "AKGTMOAuth2AuthController.h"

#import <AuthKit/AKAuthHandler.h>
#import <AuthKit/AKAccount.h>
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>
#import <gtm-oauth2/GTMOAuth2Authentication.h>
#import <gtm-oauth2/GTMOAuth2SignIn.h>

#import "AKGTMOAuth2Account.h"
#import "QIAccountStore.h"

typedef  void (^GTMOAuth2CompletionHandler)(GTMOAuth2ViewControllerTouch *viewController,
                                            GTMOAuth2Authentication *auth,
                                            NSError *error);

@implementation AKGTMOAuth2AuthController

- (void)beginAuthenticationAttempt {
  GTMOAuth2Authentication *auth = [self newGTMOAuth2Authentication];
  if (!auth) {
    // TODO(rcacheaux): Handle this case.
    return;
  }
  
  BOOL isAuthenticated =
      [GTMOAuth2ViewControllerTouch authorizeFromKeychainForName:self.keychainItemName
                                                  authentication:auth];
  if (isAuthenticated) {
    AKGTMOAuth2Account *account =
          (AKGTMOAuth2Account *)[[QIAccountStore sharedStore] newAccount];
    [[QIAccountStore sharedStore] saveAccount:account];
    [self.authHandler authControllerAccount:account didAuthenticate:self];
    return;
  }
  
  AKGTMOAuth2AuthController __weak *weakSelf = self;
  
  GTMOAuth2CompletionHandler completionHandler =
      ^(GTMOAuth2ViewControllerTouch *viewController,
        GTMOAuth2Authentication *auth,
        NSError *error)
  {
    if (!error) {
      AKGTMOAuth2Account *account =
          (AKGTMOAuth2Account *)[[QIAccountStore sharedStore] newAccount];
      [[QIAccountStore sharedStore] saveAccount:account];
      [weakSelf.authHandler authControllerAccount:account didAuthenticate:weakSelf];
    } else {
      // Log error.
    }
  };
  
  auth = [self newGTMOAuth2Authentication];
  NSURL *authURL =
      [NSURL URLWithString:self.authCodeURLString];
  GTMOAuth2ViewControllerTouch *googleOAuth2WebViewController =
      [GTMOAuth2ViewControllerTouch controllerWithAuthentication:auth
                                                authorizationURL:authURL
                                                keychainItemName:self.keychainItemName
                                               completionHandler:completionHandler];
  
  googleOAuth2WebViewController.signIn.additionalAuthorizationParameters =
      @{ @"state" : @"98797542" };
  if (self.authHandler) {
    [self.authHandler presentAKLoginViewController:googleOAuth2WebViewController];
  }
}

- (void)unauthenticateAccount:(AKAccount *)account {
  [[[QIAccountStore sharedStore] authenticatedAccount] clearCredential];
  [self.authHandler authControllerAccount:account didUnauthenticate:self];
}

- (GTMOAuth2Authentication *)newGTMOAuth2Authentication; {
  NSURL *tokenURL =
      [NSURL URLWithString:self.accessTokenURLString];
  GTMOAuth2Authentication *auth =
      [GTMOAuth2Authentication authenticationWithServiceProvider:self.serviceName
                                                        tokenURL:tokenURL
                                                     redirectURI:self.redirectURIString
                                                        clientID:self.clientID
                                                    clientSecret:self.clientSecret];
  auth.scope = self.scope;
  return auth;
}

@end
