
#import "QIStatsView.h"

@interface QIStatsView ()

@property (nonatomic,strong) UIImageView *viewBackground;

@end

@implementation QIStatsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewBackground = [self newViewBackground];
      [self contstructViewHierarchy];
    }
    return self;
}

#pragma mark Layout
-(void)contstructViewHierarchy{
  [self addSubview:self.viewBackground];
}

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

//header view with overall stats.
// 3 sections
  // Well Known
  // Needs Improvement
  // No Questions Yet


@end
