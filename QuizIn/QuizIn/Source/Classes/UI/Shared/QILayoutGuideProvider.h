#import <Foundation/Foundation.h>

@protocol QILayoutGuideProvider <NSObject>

- (id<UILayoutSupport>)topLayoutGuide;
- (id<UILayoutSupport>)bottomLayoutGuide;

@end
