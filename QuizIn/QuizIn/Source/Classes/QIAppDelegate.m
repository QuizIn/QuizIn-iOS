#import "QIAppDelegate.h"

#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#import "QIApplicationViewController.h"
//#import "QILoginScreenViewController.h"

#import "LinkedIn.h"
#import "QIIAPHelper.h"

int ddLogLevel;

@implementation QIAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [QIIAPHelper sharedInstance]; 
  [self setUpCocoaLumberjackLoggers];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
 // QILoginScreenViewController *loginViewController = [QILoginScreenViewController new];
 // self.window.rootViewController = loginViewController;
  
  QIApplicationViewController *applicationViewController = [QIApplicationViewController new];
  self.window.rootViewController = applicationViewController;
  [self.window makeKeyAndVisible];

  return YES;
}

- (void)setUpCocoaLumberjackLoggers {
#ifdef DEBUG
  ddLogLevel = LOG_LEVEL_VERBOSE;
#else
  ddLogLevel = LOG_LEVEL_ERROR;
#endif
  [DDLog addLogger:[DDASLLogger sharedInstance]];
  [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

@end
