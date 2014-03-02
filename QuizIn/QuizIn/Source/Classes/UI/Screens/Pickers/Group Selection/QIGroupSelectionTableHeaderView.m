
#import "QIGroupSelectionTableHeaderView.h"
#import "QIFontProvider.h"

@interface QIGroupSelectionTableHeaderView ()

@property (nonatomic,strong) UIView *headerBackgroundView;
@property (nonatomic,strong) UILabel *sectionTitleLabel;
@property (nonatomic,strong) NSMutableArray *selfConstraints;
@property (nonatomic,strong) NSMutableArray *sectionViewConstraints;

@end

@implementation QIGroupSelectionTableHeaderView


+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

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
    
    //Constrain Views
    NSDictionary *views = NSDictionaryOfVariableBindings(_sectionTitleLabel);
    
    NSArray *hLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-4-[_sectionTitleLabel]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    NSArray *vLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-2-[_sectionTitleLabel]-2-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    self.sectionViewConstraints = [NSMutableArray array];
    [self.sectionViewConstraints addObjectsFromArray:hLabelConstraints];
    [self.sectionViewConstraints addObjectsFromArray:vLabelConstraints];
    
    [self addConstraints:self.sectionViewConstraints];
  }
}

#pragma mark Factory Methods

-(UILabel *)newSectionTitleLabel{
  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.font = [QIFontProvider fontWithSize:14.0f style:Regular];
  titleLabel.adjustsFontSizeToFitWidth = YES;
  titleLabel.textColor = [UIColor colorWithWhite:.9f alpha:1.0f];
  [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return titleLabel;
}


@end
