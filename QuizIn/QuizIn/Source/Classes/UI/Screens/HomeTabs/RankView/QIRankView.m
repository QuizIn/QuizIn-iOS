#import "QIFontProvider.h"
#import "QIRankView.h"

@interface QIRankView ()

@property (nonatomic,strong) UILabel *rankLabel; 

@end
@implementation QIRankView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _rankLabel = [self newViewLabel];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark Layout
- (void)constructViewHierarchy{
  [self addSubview:self.rankLabel];
}

#pragma mark Properties
- (void)setRank:(NSString *)rank{
  _rank = rank;
  [self updateRank];
}

#pragma mark Actions
- (void)updateRank{
  self.rankLabel.text = self.rank;
  NSLog(self.rank); 
}

#pragma mark Factory Methods

- (UILabel *)newViewLabel {
  UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
  viewLabel.textAlignment = NSTextAlignmentLeft;
  viewLabel.backgroundColor = [UIColor clearColor];
  viewLabel.font = [QIFontProvider fontWithSize:15.0f style:Bold];
  viewLabel.adjustsFontSizeToFitWidth = YES;
  viewLabel.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [viewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return viewLabel;
}
@end
