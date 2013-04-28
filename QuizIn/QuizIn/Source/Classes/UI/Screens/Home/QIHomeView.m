#import "QIHomeView.h"

@interface QIHomeView ()
@property(nonatomic, strong) UIButton *connectionsQuizButton;
@end

@implementation QIHomeView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    _connectionsQuizButton = [self newConnectionsQuizButton];
    [self constructViewHierachy];
  }
  return self;
}

- (void)constructViewHierachy {
  [self addSubview:self.connectionsQuizButton];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  // TODO(rcacheaux): Use autolayout.
  self.connectionsQuizButton.center = CGPointMake(CGRectGetMidX(self.bounds),
                                                  CGRectGetMidY(self.bounds));
  self.connectionsQuizButton.bounds = CGRectMake(0.0f, 0.0f, 80.0f, 44.0f);
}

#pragma mark Factory Methods

- (UIButton *)newConnectionsQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:[self connectionsQuizButtonTitle] forState:UIControlStateNormal];
  return button;
}

#pragma mark Strings

- (NSString *)connectionsQuizButtonTitle {
  return @"Take Quiz";
}

@end
