#import "QIQuizView.h"

@interface QIQuizView ()
@end

@implementation QIQuizView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    [self constructViewHierachy];
  }
  return self;
}

- (void)constructViewHierachy {
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}

#pragma mark Factory Methods

@end
