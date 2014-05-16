#import "QIAppDelegate.h"
#import "QIReachabilityManager.h"

#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#import "QIApplicationViewController.h"

#import "LinkedIn.h"
#import "QIIAPHelper.h"

int ddLogLevel;

@implementation QIAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self setUpCocoaLumberjackLoggers];
  [QIReachabilityManager sharedManager];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
