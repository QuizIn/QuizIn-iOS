
#import "QIStoreSectionHeaderView.h"
#import "QIFontProvider.h"

@interface QIStoreSectionHeaderView ()

@property (nonatomic, strong) UILabel *sectionTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *checkmarkImageView;
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
      _checkmarkImageView = [self newCheckmarkImageView];
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

- (void)setPurchased:(BOOL)purchased{
  _purchased = purchased;
  [self updatePurchasedState];
}

#pragma mark Data Layout
- (void)updateSectionTitleLabel{
  NSArray *strings = [self.sectionTitle componentsSeparatedByString:@" "];
  NSMutableArray *lengths = [NSMutableArray array];
  NSString *finalString = @"";
  for (int i = 0; i<[strings count]; i++){
    finalString = [finalString stringByAppendingString:[strings objectAtIndex:i]];
    [lengths addObject:[NSNumber numberWithInteger:[[strings objectAtIndex:i] length]]];
  }
  
  NSMutableAttributedString *labelAttributes = [[NSMutableAttributedString alloc] initWithString:finalString];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:20.0f style:Regular] range:NSMakeRange(0,labelAttributes.length)];
  
  NSNumber *runningTotal = @(0);
  UIColor *currentColor;
  for (int i=0;i<[lengths count];i++){
    if (i%2 == 0){
      currentColor = [UIColor colorWithWhite:.4 alpha:1.0f];
    }
    else{
      currentColor = [UIColor colorWithWhite:.6 alpha:1.0f];
    }
    [labelAttributes addAttribute:NSForegroundColorAttributeName value:currentColor range:NSMakeRange([runningTotal intValue],[[lengths objectAtIndex:i] intValue])];

    runningTotal = @([[lengths objectAtIndex:i]integerValue] + [runningTotal integerValue]);
  }
  [self.sectionTitleLabel setAttributedText:labelAttributes];
}

- (void)updatePrice{
  self.priceLabel.text = self.price;
}

-(void)updatePurchasedState{
  self.priceLabel.hidden = self.purchased;
  self.checkmarkImageView.hidden = !self.purchased;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.sectionTitleLabel];
  [self addSubview:self.priceLabel];
  [self addSubview:self.checkmarkImageView];
}

#pragma mark Constraints
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraints){
    self.constraints = [NSMutableArray array];
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_sectionTitleLabel,_priceLabel,_checkmarkImageView);
    
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_sectionTitleLabel]-(>=10)-[_priceLabel]-30-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:headerViews];
    
    NSArray *vTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sectionTitleLabel]|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSArray *vPriceConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_priceLabel]|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSLayoutConstraint *hCheckmark = [NSLayoutConstraint constraintWithItem:_checkmarkImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_priceLabel attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCheckmark = [NSLayoutConstraint constraintWithItem:_checkmarkImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_priceLabel attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];

    
    [self.constraints addObjectsFromArray:hTitleConstraints];
    [self.constraints addObjectsFromArray:vTitleConstraints];
    [self.constraints addObjectsFromArray:vPriceConstraints];
    [self.constraints addObjectsFromArray:@[hCheckmark, vCheckmark]];
    
    [self addConstraints:self.constraints]; 

  }
}

- (UILabel *)newPriceLabel{
  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  label.font = [QIFontProvider fontWithSize:16.0f style:Regular];
  label.adjustsFontSizeToFitWidth = YES;
  label.textColor = [UIColor colorWithWhite:0.40f alpha:1.0f];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

- (UILabel *)newTitleLabel {
  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  label.adjustsFontSizeToFitWidth = YES;
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

-(UIImageView *)newCheckmarkImageView{
  UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_checkmark"]];
  [check setContentMode:UIViewContentModeScaleAspectFit];
  [check setTranslatesAutoresizingMaskIntoConstraints:NO];
  return check;
}

@end
