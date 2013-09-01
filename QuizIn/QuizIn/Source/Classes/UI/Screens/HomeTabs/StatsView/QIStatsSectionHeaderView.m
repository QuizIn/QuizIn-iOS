
#import "QIStatsSectionHeaderView.h"
#import "QIFontProvider.h"

@interface QIStatsSectionHeaderView ()

@property (nonatomic, strong) UIImageView *divider;
@property (nonatomic, strong) UILabel *sectionTitleLabel;

@property (nonatomic, strong) NSMutableArray *constraints; 

@end


@implementation QIStatsSectionHeaderView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _divider = [self newDivider];
      _sectionTitleLabel = [self newTitleLabel];
      
      [self constructViewHierarchy]; 
    }
    return self;
}
#pragma mark Properties
- (void)setSectionTitle:(NSString *)sectionTitle{
  _sectionTitle = sectionTitle;
  [self updateSectionTitleLabel];
}

#pragma mark Data Layout
- (void)updateSectionTitleLabel{
  self.sectionTitleLabel.text = self.sectionTitle; 
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.divider];
  [self addSubview:self.sectionTitleLabel]; 
}

#pragma mark Constraints
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraints){
    self.constraints = [NSMutableArray array];
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_divider, _sectionTitleLabel);
  
    //Place Sign
    NSArray *hDividerConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_divider]-10-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_sectionTitleLabel]|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSArray *vHeaderConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_sectionTitleLabel][_divider(==2)]-3-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    [self.constraints addObjectsFromArray:hDividerConstraints];
    [self.constraints addObjectsFromArray:hTitleConstraints];
    [self.constraints addObjectsFromArray:vHeaderConstraints];
    
    [self addConstraints:self.constraints]; 

  }
}
- (UIImageView *)newDivider{
  UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_divider"]];
  [divider setTranslatesAutoresizingMaskIntoConstraints:NO];
  return divider;
}

- (UILabel *)newTitleLabel {
  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  label.font = [QIFontProvider fontWithSize:15.0f style:Bold];
  label.adjustsFontSizeToFitWidth = YES;
  label.textColor = [UIColor colorWithWhite:0.50f alpha:1.0f];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

@end
