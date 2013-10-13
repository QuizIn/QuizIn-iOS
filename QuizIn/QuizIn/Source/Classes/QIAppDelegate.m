#import "QIAppDelegate.h"

#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#import "QIApplicationViewController.h"

#import "LinkedIn.h"
#import "QIIAPHelper.h"

int ddLogLevel;

@implementation QIAppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [QIIAPHelper sharedInstance]; 
  [self setUpCocoaLumberjackLoggers];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  QIApplicationViewController *applicationViewController = [QIApplicationViewController new];
  self.window.rootViewController = applicationViewController;
  [self.window makeKeyAndVisible];
  
  /*
   {
   code = "us:0";
   count = 204;
   name = "United States";
   },
   {
   code = "us:64";
   count = 176;
   name = "Austin, Texas Area";
   },
   {
   code = "in:0";
   count = 7;
   name = India;
   },
   {
   code = "in:6508";
   count = 6;
   name = "Hyderabad Area, India";
   },
   {
   code = "us:84";
   count = 5;
   name = "San Francisco Bay Area";
   },
   {
   code = "us:724";
   count = 4;
   name = "San Antonio, Texas Area";
   },
   {
   code = "hu:0";
   count = 3;
   name = Hungary;
   },
   {
   code = "mx:0";
   count = 2;
   name = Mexico;
   },
   {
   code = "us:31";
   count = 2;
   name = "Dallas/Fort Worth Area";
   },
   {
   code = "us:70";
   count = 2;
   name = "Greater New York City Area";
   }*/
  
  
  //facets:(code,buckets:(code,name,count)) //  // current-company //@"facets": @"location",
  [LinkedIn
   allFirstDegreeConnectionsForAuthenticatedUserInLocations:@[@"us:0"]
   onCompletion:^(QIConnectionsStore *connectionsStore, NSError *error) {
    NSLog(@"Done");
  }];
  
  
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
