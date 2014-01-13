
#import "QIStoreSectionHeaderView.h"
#import "QIFontProvider.h"

@interface QIStoreSectionHeaderView ()

@property (nonatomic, strong) UILabel *sectionTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) NSMutableArray *constraints; 

@end

@implementation QIStoreSectionHeaderView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _sectionTitleLabel = [self newTitleLabel];
      _priceLabel = [self newPriceLabel];
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark Properties
- (void)setSectionTitle:(NSString *)sectionTitle{
  _sectionTitle = sectionTitle;
  [self updateSectionTitleLabel];
}

- (void)setPrice:(NSString *)price{
  _price = price;
  [self updatePrice];
}

#pragma mark Data Layout
- (void)updateSectionTitleLabel{
  self.sectionTitleLabel.text = self.sectionTitle; 
}

- (void)updatePrice{
  self.priceLabel.text = self.price;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
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
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_sectionTitleLabel);
    
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_sectionTitleLabel]|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSArray *vHeaderConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_sectionTitleLabel]-5-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    [self.constraints addObjectsFromArray:hTitleConstraints];
    [self.constraints addObjectsFromArray:vHeaderConstraints];
    
    [self addConstraints:self.constraints]; 

  }
}

- (UILabel *)newPriceLabel{
  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  label.font = [QIFontProvider fontWithSize:15.0f style:Bold];
  label.adjustsFontSizeToFitWidth = YES;
  label.textColor = [UIColor colorWithWhite:0.50f alpha:1.0f];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
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
