#import "QIFontProvider.h"
#import "QIStoreView.h"

@implementation QIStoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self addSubview:[self newViewLabel]];
    }
    return self;
}

- (UILabel *)newViewLabel {
  UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
  viewLabel.text = @"Store";
  viewLabel.textAlignment = NSTextAlignmentLeft;
  viewLabel.backgroundColor = [UIColor clearColor];
  viewLabel.font = [QIFontProvider fontWithSize:15.0f style:Bold];
  viewLabel.adjustsFontSizeToFitWidth = YES;
  viewLabel.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [viewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [viewLabel setNumberOfLines:30];
  return viewLabel;
}
@end
