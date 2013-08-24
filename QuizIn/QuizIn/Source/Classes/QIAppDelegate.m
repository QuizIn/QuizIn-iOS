#import "QIAppDelegate.h"

#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#import "QIApplicationViewController.h"

#import "QILISearch.h"

int ddLogLevel;

@implementation QIAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [self setUpCocoaLumberjackLoggers];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  QIApplicationViewController *applicationViewController = [QIApplicationViewController new];
  self.window.rootViewController = applicationViewController;
  //self.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
  [self.window makeKeyAndVisible];
  
  /*
  //facets:(code,buckets:(code,name,count))
  [QILISearch getPeopleSearchWithFieldSelector:@"(people:(first-name))"
                              searchParameters:@{@"facets": @"current-company",
                                                 @"facet": @[@"network,F", @"location,us:84"]}
                                  onCompletion:^(NSArray *people, NSError *error) {
    NSLog(@"DONE");
  }];*/
  
  
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
