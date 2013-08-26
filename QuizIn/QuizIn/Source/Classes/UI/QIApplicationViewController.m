#import "QIApplicationViewController.h"
#import <AuthKit/AKAuthHandler.h>
#import "AKLinkedInAuthController.h"
#import "QIDrawerController.h"
#import "QIHomeViewController.h"

//Tab Bar Views
#import "QIHomeViewController.h"
#import "QIStatsViewController.h"
#import "QIRankViewController.h"
#import "QIStoreViewController.h"

// TODO(rcacheaux):  Remove Temp Stuff.
#import "LinkedIn.h"
#import "QIConnectionsStore.h"
#import "QIQuizFactory.h"
#import "QIQuiz.h"

#define USERID @"12345"

@interface QIApplicationViewController ()<AKAuthHandler>
//@property(nonatomic, strong) QIDrawerController *drawerController;
@property(nonatomic, strong) UIViewController *loginViewController;
@property(nonatomic, strong) AKLinkedInAuthController *authController;
@property(nonatomic, strong) UITabBarController *tabViewController;
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
  [self.authController beginAuthenticationAttempt];
//  [self authControllerAccount:nil didAuthenticate:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Layout

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  //self.drawerController.view.frame = self.view.bounds;
  self.tabViewController.view.frame = self.view.bounds; 
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
  
  self.tabViewController = [self newTabBarController];
  [self addChildViewController:self.tabViewController];
  [self.view addSubview:self.tabViewController.view];
  //self.drawerController = [self newDrawerController];
  //[self addChildViewController:self.drawerController];
  //[self.view addSubview:self.drawerController.view];
}

- (void)authControllerAccount:(AKAccount *)account
            didUnauthenticate:(id<AKAuthControl>)authController {
  
  [self.tabBarController.view removeFromSuperview];
  [self.tabBarController removeFromParentViewController];
  //[self.drawerController.view removeFromSuperview];
  //[self.drawerController removeFromParentViewController];
}

#pragma mark Factory Methods

- (AKLinkedInAuthController *)newLinkedInAuthController {
  AKLinkedInAuthController *authController = [[AKLinkedInAuthController alloc] init];
  authController.authHandler = self;
  return authController;
}

- (UITabBarController *)newTabBarController{
  UITabBarController *tabController = [[UITabBarController alloc] init];
  [tabController setViewControllers:@[[self newHomeViewController],[self newStatsViewController],[self newRankViewController],[self newStoreViewController]]];
  [tabController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
  [tabController.tabBar setTintColor:[UIColor colorWithWhite:.15f alpha:1.0f]];
  //[tabController setModalPresentationStyle:UIModalPresentationCurrentContext];
  return tabController; 
}
- (QIDrawerController *)newDrawerController {
  QIDrawerController *drawerController = [[QIDrawerController alloc] init];
  [drawerController updateViewControllers:@[[self newHomeViewController]]];
  return drawerController;
}

- (QIHomeViewController *)newHomeViewController {
  QIHomeViewController *homeViewController = [[QIHomeViewController alloc] init];
  [homeViewController setTitle:@"Home"];
  [homeViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"connectionsquiz_home_btn"] tag:0]];
  [homeViewController setUserID:USERID];
  return homeViewController;
}

- (QIStatsViewController *)newStatsViewController {
  QIStatsViewController *statsViewController = [[QIStatsViewController alloc] init];
  [statsViewController setTitle:@"Stats"];
  [statsViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Stats" image:[UIImage imageNamed:@"connectionsquiz_stats_btn"] tag:1]];
  [statsViewController setUserID:USERID];
  return statsViewController;
}

- (QIRankViewController *)newRankViewController {
  QIRankViewController *rankViewController = [[QIRankViewController alloc] init];
  [rankViewController setTitle:@"Rank"];
  [rankViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Rank" image:[UIImage imageNamed:@"connectionsquiz_rank_btn"] tag:2]];
  [rankViewController setUserID:USERID];
  return rankViewController;
}

- (QIStoreViewController *)newStoreViewController {
  QIStoreViewController *storeViewController = [[QIStoreViewController alloc] init];
  [storeViewController setTitle:@"Store"];
  [storeViewController setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Store" image:[UIImage imageNamed:@"connectionsquiz_store_btn"] tag:3]];
  return storeViewController;
}

@end
