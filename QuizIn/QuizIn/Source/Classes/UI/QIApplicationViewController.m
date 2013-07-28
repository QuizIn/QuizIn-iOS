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
#import "QIConnections.h"
#import "QIQuizBuilder.h"
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
  
  /*
  QIQuiz *quiz = [QIQuizBuilder quizFromRandomConnections];
  NSLog(@"%@", quiz);*/
  
  /*
  [LinkedIn getPeopleCurrentUserConnectionsCountWithOnSuccess:^(NSInteger numberOfConnections) {
    NSLog(@"Number of Connections: %d", numberOfConnections);
  } onFailure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];*/
  
  /*
  [LinkedIn getPeopleConnectionsWithStartIndex:0 count:10 onSuccess:^(QIConnections *connections) {
    NSLog(@"Connections: %@", connections.people);
  } onFailure:^(NSError *error) {
    NSLog(@"Error: %@", error);
  }];*/
  
  
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
  [homeViewController setUserID:USERID];
  return homeViewController;
}

- (QIStatsViewController *)newStatsViewController {
  QIStatsViewController *statsViewController = [[QIStatsViewController alloc] init];
  [statsViewController setTitle:@"Stats"];
  [statsViewController setUserID:USERID];
  return statsViewController;
}

- (QIStoreViewController *)newStoreViewController {
  QIStoreViewController *storeViewController = [[QIStoreViewController alloc] init];
  [storeViewController setTitle:@"Store"];
  return storeViewController;
}

- (QIRankViewController *)newRankViewController {
  QIRankViewController *rankViewController = [[QIRankViewController alloc] init];
  [rankViewController setTitle:@"Rank"];
  [rankViewController setUserID:USERID];
  return rankViewController;
}

@end
