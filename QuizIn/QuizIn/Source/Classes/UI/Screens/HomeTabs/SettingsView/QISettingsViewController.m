
#import "QISettingsViewController.h"
#import "QIPerson.h"
#import "LinkedIn.h"

@interface QISettingsViewController ()

@property (nonatomic,strong) QIPerson *loggedInUser;

@end

@implementation QISettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _loggedInUser = [LinkedIn authenticatedUser];
    }
    return self;
}

- (void)loadView{
  self.view = [[QISettingsView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.settingsView setFirstName:self.loggedInUser.firstName];
  [self.settingsView setLastName:self.loggedInUser.lastName]; 
  [self.settingsView setTitle:self.loggedInUser.industry];
  [self.settingsView setProfileImageURL:[NSURL URLWithString:self.loggedInUser.pictureURL]];
  [self.settingsView.logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Actions
- (void) logout{
  NSLog(@"logout");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QISettingsView *)settingsView {
  return (QISettingsView *)self.view;
}

- (void)setParentTabBarController:(UITabBarController *)parentTabBarController{
  _parentTabBarController = parentTabBarController;
}


@end
