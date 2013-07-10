
#import "QIStatsView.h"

@implementation QIStatsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self setBackgroundColor:[UIColor greenColor]];
      UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      [statsViewButton setTitle:@"Matching" forState:UIControlStateNormal];
      statsViewButton.frame = CGRectMake(200.0f, 380.0f, 150.0f, 44.0f);
      [self addSubview:statsViewButton];
    }
    return self;
}

//header view with overall stats.
// 3 sections
  // Well Known
  // Needs Improvement
  // No Questions Yet


@end
