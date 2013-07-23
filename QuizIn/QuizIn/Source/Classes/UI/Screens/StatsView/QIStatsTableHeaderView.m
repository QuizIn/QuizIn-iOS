
#import "QIStatsTableHeaderView.h"
#import "QIFontProvider.h"

@interface QIStatsTableHeaderView ()

@property (nonatomic,strong) UILabel *sectionTitleLabel;
@property (nonatomic,strong) NSMutableArray *selfConstraints;
@property (nonatomic,strong) NSMutableArray *sectionViewConstraints;

@end

@implementation QIStatsTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _sectionTitleLabel = [self newSectionTitleLabel];
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
-(void)constructViewHierarchy{
  [self addSubview:self.sectionTitleLabel];
}

#pragma mark Properties
-(void)setSectionTitle:(NSString *)sectionTitle{
  _sectionTitle = sectionTitle;
  [self updateTitle];
}

#pragma mark Data Display
-(void)updateTitle{
  self.sectionTitleLabel.text = self.sectionTitle;
  [self updateConstraints];
}

#pragma mark Layout

-(void)layoutSubviews{
  [super layoutSubviews];
}

-(void)updateConstraints{
  [super updateConstraints];
  if (!self.sectionViewConstraints) {
    
  }
}

#pragma mark Factory Methods

-(UILabel *)newSectionTitleLabel{
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = [QIFontProvider fontWithSize:14.0f style:Regular];
  titleLabel.adjustsFontSizeToFitWidth = YES;
  titleLabel.textColor = [UIColor colorWithWhite:.9f alpha:1.0f];
  [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return titleLabel;
}

@end