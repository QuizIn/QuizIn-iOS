#import "QIApplicationViewController.h"

#import <AuthKit/AKAuthHandler.h>

#import "AKLinkedInAuthController.h"
#import "QIDrawerController.h"
#import "QIHomeViewController.h"

// TODO(rcacheaux):  Remove Temp Stuff.
#import "LinkedIn.h"

@interface QIApplicationViewController ()<AKAuthHandler>
@property(nonatomic, strong) QIDrawerController *drawerController;
@property(nonatomic, strong) UIViewController *loginViewController;
@property(nonatomic, strong) AKLinkedInAuthController *authController;
@end

@implementation QIApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _authController = [self newLinkedInAuthController];
  }
  return self;
}

- (void) loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //[self.authController beginAuthenticationAttempt];
  [self authControllerAccount:nil didAuthenticate:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Layout

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.drawerController.view.frame = self.view.bounds;
  self.loginViewController.view.frame = self.view.bounds;
}

#pragma mark AKAuthHandler

- (void)presentAKLoginViewController:(UIViewController *)viewController {
  self.loginViewController = viewController;
  [self addChildViewController:viewController];
  [self.view addSubview:viewController.view];
}

- (void)authControllerAccount:(AKAccount *)account
              didAuthenticate:(id<AKAuthControl>)authController {
  // TODO(rcacheaux): Check if exists.
  [self.loginViewController.view removeFromSuperview];
  [self.loginViewController removeFromParentViewController];
  
  self.drawerController = [self newDrawerController];
  [self addChildViewController:self.drawerController];
  [self.view addSubview:self.drawerController.view];
 /*
  [LinkedIn getPeopleCurrentConnectionsWithCompletionHandler:^(NSArray *connections,
                                                               NSError *error) {
    NSLog(@"Got Connections");
    for (NSDictionary *person in connections) {
      [LinkedIn getPeopleWithID:person[@"id"] completionHandler:^(NSDictionary *profile,
                                                                  NSError *error) {
        NSLog(@"Company: %@", profile[@"positions"][@"values"][0][@"company"][@"name"]);
      }];
    }
  }];
  */
}

- (void)authControllerAccount:(AKAccount *)account
            didUnauthenticate:(id<AKAuthControl>)authController {
  [self.drawerController.view removeFromSuperview];
  [self.drawerController removeFromParentViewController];
}

#pragma mark Factory Methods

- (AKLinkedInAuthController *)newLinkedInAuthController {
  AKLinkedInAuthController *authController = [[AKLinkedInAuthController alloc] init];
  authController.authHandler = self;
  return authController;
}

- (QIDrawerController *)newDrawerController {
  QIDrawerController *drawerController = [[QIDrawerController alloc] init];
  [drawerController updateViewControllers:@[[self newHomeViewController]]];
  return drawerController;
}

- (QIHomeViewController *)newHomeViewController {
  QIHomeViewController *homeViewController = [[QIHomeViewController alloc] init];
  return homeViewController;
}

@end
