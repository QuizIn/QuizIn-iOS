
#import "QISettingsViewController.h"
#import "QIPerson.h"
#import "LinkedIn.h"
#import "QIApplicationViewController.h"
#import "QIStatsData.h"

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
  [self.settingsView.clearStatsButton addTarget:self action:@selector(clearStats) forControlEvents:UIControlEventTouchUpInside];
}
#pragma Properties

- (void)setUserID:(NSString *)userID{
  _userID = userID;
}

#pragma mark Actions
- (void) logout{
  if (self.applicationViewController) {
    [self.applicationViewController logout];
    return;
  }
  NSAssert(NO, @"Warning: Settings view controller does not have a reference to the application view controller; can't logout.");
}

- (void)clearStats{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Stats" message:@"Just to confirm, you are about to delete all stats and reset your rank." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset",nil];
  [alert show];
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

#pragma UIAlertView Delegate Functions
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1){
    QIStatsData *data = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
    [data setUpStats];
  }
}


@end
