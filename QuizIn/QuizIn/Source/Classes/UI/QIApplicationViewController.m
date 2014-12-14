#import "QIApplicationViewController.h"
#import <AuthKit/AKAuthHandler.h>
#import "AKLinkedInAuthController.h"
#import "QIHomeViewController.h"
#import "QILoginScreenViewController.h"
#import "QIReachabilityManager.h"
#import <gtm-oauth2/GTMOAuth2ViewControllerTouch.h>

//Tab Bar Views
#import "QIHomeViewController.h"
#import "QIStatsViewController.h"
#import "QIRankViewController.h"
#import "QIStoreViewController.h"
#import "QISettingsViewController.h"

// TODO(rcacheaux):  Remove Temp Stuff.
#import "LinkedIn.h"
#import "QICompany.h"
#import "QIConnectionsStore.h"
#import "QIQuizFactory.h"
#import "QIQuiz.h"

@interface QIApplicationViewController ()<AKAuthHandler>
@property (nonatomic, strong) UIViewController *loginViewController;
@property (nonatomic, strong) AKLinkedInAuthController *authController;
@property (nonatomic, strong) UITabBarController *tabViewController;
@property (nonatomic, strong) QIPerson *loggedInUser;
@property (nonatomic, strong) AKAccount *loggedInAccount;
@property (nonatomic, strong) UINavigationController *mainNav;
@property (nonatomic, strong) QILoginScreenViewController *loginScreenController;
@property (nonatomic) BOOL isWaitingForLogin;
@end

@implementation QIApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _authController = [self newLinkedInAuthController];
    _isWaitingForLogin = NO;
    
    // rtodo make factory
    _mainNav = [UINavigationController new];
    _mainNav.navigationBarHidden = YES;
  }
  return self;
}

- (void) loadView {
  self.view = [[UIView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.mainNav willMoveToParentViewController:self];
  self.mainNav.view.frame = self.view.bounds;
  [self.view addSubview:self.mainNav.view];
  [self addChildViewController:self.mainNav];
  
  QILoginScreenViewController *landingViewController = [QILoginScreenViewController new];
  landingViewController.appViewController = self;
  self.loginScreenController = landingViewController;
  [self.mainNav pushViewController:landingViewController animated:NO];
  
  self.isWaitingForLogin = YES;
  [self.authController beginAuthenticationAttempt];
  while (self.isWaitingForLogin) {
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
  }
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

-(void)login {
  [self.authController beginAuthenticationAttempt];
  if ([QIReachabilityManager isReachable]) {
    [self.mainNav pushViewController:self.loginViewController animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
  else{
    [self connectionAlert];
  }
}

- (void)logout {
  [self.authController unauthenticateAccount:self.loggedInAccount];
}

- (void)connectionAlert{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You must have a connection to the internet to login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}

#pragma mark Layout

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.tabViewController.view.frame = self.view.bounds;
  self.loginViewController.view.frame = self.view.bounds;
}

#pragma mark AKAuthHandler

- (void)presentAKLoginViewController:(UIViewController *)viewController {
  self.loginViewController = viewController;
  self.isWaitingForLogin = NO;
}

- (void)authControllerAccount:(AKAccount *)account
              didAuthenticate:(id<AKAuthControl>)authController {
  self.loginScreenController.loginScreenView.thinkingIndicator = YES;
  self.loggedInAccount = account;
  [LinkedIn updateAuthenticatedUserWithOnCompletion:^(QIPerson *authenticatedUser, NSError *error) {
    [QIIAPHelper sharedInstance]; 
    // TODO(rcacheaux): Check if exists.
    self.loggedInUser = [LinkedIn authenticatedUser];
    self.tabViewController = [self newTabBarController];
    [self.mainNav pushViewController:self.tabViewController animated:NO];
    self.isWaitingForLogin = NO;
    if (self.presentedViewController) {
      [self dismissViewControllerAnimated:YES completion:nil];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
  }];
  
}

- (void)authControllerAccount:(AKAccount *)account
            didUnauthenticate:(id<AKAuthControl>)authController {
  self.loginScreenController.loginScreenView.thinkingIndicator = NO;
  [LinkedIn updateAuthenticatedUserWithOnCompletion:nil];
  self.isWaitingForLogin = NO;
  [self.mainNav popViewControllerAnimated:YES];
  [self.authController beginAuthenticationAttempt];
}

#pragma mark Factory Methods

- (AKLinkedInAuthController *)newLinkedInAuthController {
  AKLinkedInAuthController *authController = [[AKLinkedInAuthController alloc] init];
  authController.authHandler = self;
  return authController;
}

- (UITabBarController *)newTabBarController{
  UITabBarController *tabController = [[UITabBarController alloc] init];
  [tabController setViewControllers:@[[self newHomeViewController],[self newStatsViewController],[self newRankViewController],[self newSettingsViewController],[self newStoreViewController]]];
  QIHomeViewController *homeViewController = (QIHomeViewController *)[tabController.viewControllers objectAtIndex:0];
  homeViewController.parentTabBarController = tabController; 
  QIStatsViewController *statsViewController = (QIStatsViewController *)[tabController.viewControllers objectAtIndex:1];
  statsViewController.parentTabBarController = tabController;
  QIRankViewController *rankViewController = (QIRankViewController *)[tabController.viewControllers objectAtIndex:2];
  rankViewController.parentTabBarController = tabController;
  QISettingsViewController *settingsViewController = (QISettingsViewController *)[tabController.viewControllers objectAtIndex:3];
  settingsViewController.parentTabBarController = tabController;
  QIStoreViewController *storeViewController = (QIStoreViewController *)[tabController.viewControllers objectAtIndex:4];
  storeViewController.parentTabBarController = tabController;
  [tabController.tabBar setTintColor:[UIColor colorWithRed:.34f green:.45f blue:.64f alpha:1.0f]];
  //[tabController.tabBar setTintColor:[UIColor colorWithWhite:.15f alpha:1.0f]];
    
  //[tabController setModalPresentationStyle:UIModalPresentationCurrentContext];
  return tabController;
}

- (QIHomeViewController *)newHomeViewController {
  QIHomeViewController *homeViewController = [[QIHomeViewController alloc] init];
  //[homeViewController setApplicationViewController:self];
  [homeViewController setTitle:@"Home"];
  [homeViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Start" image:[UIImage imageNamed:@"connectionsquiz_home_btn"] tag:0]];
  [homeViewController setUserID:self.loggedInUser.personID];
  return homeViewController;
}

- (QIStatsViewController *)newStatsViewController {
  QIStatsViewController *statsViewController = [[QIStatsViewController alloc] init];
  [statsViewController setTitle:@"Stats"];
  [statsViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Stats" image:[UIImage imageNamed:@"connectionsquiz_stats_btn"] tag:1]];
  [statsViewController setUserID:self.loggedInUser.personID];
  return statsViewController;
}

- (QIRankViewController *)newRankViewController {
  QIRankViewController *rankViewController = [[QIRankViewController alloc] init];
  [rankViewController setTitle:@"Rank"];
  [rankViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Rank" image:[UIImage imageNamed:@"connectionsquiz_rank_btn"] tag:2]];
  [rankViewController setUserID:self.loggedInUser.personID];
  return rankViewController;
}

- (QIStoreViewController *)newStoreViewController {
  QIStoreViewController *storeViewController = [[QIStoreViewController alloc] init];
  [storeViewController setTitle:@"Store"];
  [storeViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Store" image:[UIImage imageNamed:@"connectionsquiz_store_btn"] tag:3]];
  return storeViewController;
}

- (QISettingsViewController *)newSettingsViewController {
  QISettingsViewController *settingsViewController = [[QISettingsViewController alloc] init];
  settingsViewController.applicationViewController = self;
  [settingsViewController setTitle:@"Settings"];
  [settingsViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"connectionsquiz_settings_btn"] tag:4]];
  return settingsViewController;
}

@end
