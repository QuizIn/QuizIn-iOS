#import "QIReachabilityManager.h"
#import "Reachability.h"

@implementation QIReachabilityManager

#pragma mark -
#pragma mark Default Manager
+ (QIReachabilityManager *)sharedManager {
  static QIReachabilityManager *_sharedManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedManager = [[self alloc] init];
  });
  
  return _sharedManager;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
  // Stop Notifier
  if (_reachability) {
    [_reachability stopNotifier];
  }
}

#pragma mark -
#pragma mark Class Methods
+ (BOOL)isReachable {
  return [[[QIReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isUnreachable {
  return ![[[QIReachabilityManager sharedManager] reachability] isReachable];
}

+ (BOOL)isReachableViaWWAN {
  return [[[QIReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}

+ (BOOL)isReachableViaWiFi {
  return [[[QIReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}

#pragma mark -
#pragma mark Private Initialization
- (id)init {
  self = [super init];
  
  if (self) {
    // Initialize Reachability
    self.reachability = [Reachability reachabilityWithHostname:@"www.linkedin.com"];
    
    // Start Monitoring
    [self.reachability startNotifier];
  }
  
  return self;
}

@end