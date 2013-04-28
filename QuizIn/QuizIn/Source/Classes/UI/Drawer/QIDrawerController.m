#import "QIDrawerController.h"

#import "QIDrawerView.h"

@interface QIDrawerController ()
@property(nonatomic, copy) NSArray *viewControllers;
@property(nonatomic, strong) UIViewController *selectedViewController;
@property(nonatomic, strong, readonly) QIDrawerView *drawerView;
@end

@implementation QIDrawerController

- (void)loadView {
  self.view = [[QIDrawerView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Public Methods

- (void)updateViewControllers:(NSArray *)viewControllers {
  self.viewControllers = viewControllers;
}

- (void)selectVisibleViewController:(UIViewController *)viewController {
  self.selectedViewController = viewController;
  UINavigationItem *titleItem =
      [[UINavigationItem alloc] initWithTitle:viewController.title];
  [self.drawerView.navigationBar setItems:@[titleItem] animated:NO];
}

#pragma mark Properties

- (void)setViewControllers:(NSArray *)viewControllers {
  if ([viewControllers isEqualToArray:_viewControllers]) {
    return;
  }
  if (!viewControllers) {
    return;
  }
  _viewControllers = [viewControllers copy];
  if ([viewControllers count] > 0) {
    [self selectVisibleViewController:viewControllers[0]];
  }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
  if ([selectedViewController isEqual:_selectedViewController]) {
    return;
  }
  if (!selectedViewController) {
    return;
  }
  if ([self viewControllerIsKnown:selectedViewController]) {
    [self hideViewController:_selectedViewController];
    _selectedViewController = selectedViewController;
    [self showViewController:_selectedViewController];
  }
}

- (QIDrawerView *)drawerView {
  return (QIDrawerView *)self.view;
}

#pragma mark Controller Container

- (void)hideViewController:(UIViewController *)viewController {
  [viewController removeFromParentViewController];
  [self.drawerView removeContentView];
  [viewController.view removeFromSuperview];
}

- (void)showViewController:(UIViewController *)viewController {
  [self addChildViewController:viewController];
  [self.drawerView displayContentView:viewController.view];
}

#pragma mark Utility

- (BOOL)viewControllerIsKnown:(UIViewController *)viewController {
  return [self.viewControllers containsObject:viewController];
}

@end
