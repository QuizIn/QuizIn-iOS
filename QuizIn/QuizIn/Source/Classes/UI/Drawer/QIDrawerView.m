#import "QIDrawerView.h"

@interface QIDrawerView ()
@property(nonatomic, strong, readwrite) UINavigationBar *navigationBar;
@property(nonatomic, strong) UIView *contentView;
@end

@implementation QIDrawerView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _navigationBar = [self newNavigationBar];
    [self constructViewHierarchy];
  }
  return self;
}

- (void)constructViewHierarchy {
  [self addSubview:self.navigationBar];
}

#pragma mark Public Methods

- (void)displayContentView:(UIView *)contentView {
  if ([contentView isEqual:self.contentView]) {
    return;
  }
  [self.contentView removeFromSuperview];
  self.contentView = contentView;
  [self addSubview:contentView];
}

- (void)removeContentView {
  [self.contentView removeFromSuperview];
  self.contentView = nil;
}

#pragma mark Factory Methods

- (UINavigationBar *)newNavigationBar {
  UINavigationBar *navigationBar = [[UINavigationBar alloc] init];
  navigationBar.tintColor = [UIColor blackColor];
  return navigationBar;
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGSize navBarSize = [self.navigationBar sizeThatFits:self.bounds.size];
  self.navigationBar.frame = CGRectMake(0.0f, 0.0f, navBarSize.width, navBarSize.height);
  
  CGRect contentViewFrame = self.bounds;
  contentViewFrame.size.height -= CGRectGetHeight(self.navigationBar.frame);
  contentViewFrame = CGRectOffset(contentViewFrame,
                                  0.0f,
                                  CGRectGetHeight(self.navigationBar.frame));
  self.contentView.frame = contentViewFrame;
}

@end
