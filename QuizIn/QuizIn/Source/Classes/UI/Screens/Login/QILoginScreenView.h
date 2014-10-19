
#import <UIKit/UIKit.h>
#import "QIFontProvider.h"

@interface QILoginScreenView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIButton *loginButton;
@property (nonatomic, assign) BOOL *thinkingIndicator;

@end
