#import "QIApplicationViewController.h"

#import <AuthKit/AKAuthControl.h>

#import "QIDrawerController.h"
#import "QIHomeViewController.h"

@interface QIApplicationViewController ()<AKAuthControl>
@property(nonatomic, strong) QIDrawerController *drawerController;
@property(nonatomic, strong) UIViewController *loginViewController;
@end

@implementation QIApplicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void) loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor redColor];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.drawerController = [self newDrawerController];
  [self addChildViewController:self.drawerController];
  [self.view addSubview:self.drawerController.view];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Layout

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.drawerController.view.frame = self.view.bounds;
}

#pragma mark Factory Methods

- (QIDrawerController *)newDrawerController {
  QIDrawerController *drawerController = [[QIDrawerController alloc] init];
  [drawerController updateViewControllers:@[[self newHomeViewController]]];
  return drawerController;
}

- (QIHomeViewController *)newHomeViewController {
  QIHomeViewController *homeViewController = [[QIHomeViewController alloc] init];
  return homeViewController;
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
  
  /*
  self.linkedInViewController = [[MALinkedInViewController alloc] init];
  self.linkedInViewController.authControl = self;
  self.linkedInViewController.view.frame = self.view.bounds;
  [self addChildViewController:self.linkedInViewController];
  [self.view addSubview:self.linkedInViewController.view];
}

- (void)authControllerAccount:(AKAccount *)account
            didUnauthenticate:(id<AKAuthControl>)authController {
  [self.linkedInViewController.view removeFromSuperview];
  [self.linkedInViewController removeFromParentViewController];
  
  [self addChildViewController:self.tourViewController];
  [self.view addSubview:self.tourViewController.view];
   */
}

@end
