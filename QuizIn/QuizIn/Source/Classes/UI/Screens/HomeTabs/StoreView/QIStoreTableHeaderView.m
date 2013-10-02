
#import "QIStoreTableHeaderView.h"
#import "QIFontProvider.h"

@interface QIStoreTableHeaderView ()

@property (nonatomic, strong) UIImageView *sign;
@property (nonatomic, strong) UILabel *bestOfferLabel;
@property (nonatomic, strong) UILabel *buyAllPriceLabel; 

@property (nonatomic, strong) NSMutableArray *constraints;

@end
@implementation QIStoreTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _sign = [self newSign];
      _buyAllButton = [self newBuyAllButton];
      _bestOfferLabel = [self newLabelWithText:@"BEST OFFER"];
      _buyAllPriceLabel = [self newLabelWithText:@"$3.99"];
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.sign];
  [self addSubview:self.buyAllButton];
  [self addSubview:self.bestOfferLabel];
  [self addSubview:self.buyAllPriceLabel];
}

#pragma mark Constraints
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraints){
    self.constraints = [NSMutableArray array];
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_sign, _buyAllButton, _bestOfferLabel, _buyAllPriceLabel);
    
    //Place Sign
    NSArray *hSignConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sign(==194)]"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSArray *vSignConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sign(==112)]"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSLayoutConstraint *centerSign = [NSLayoutConstraint constraintWithItem:_sign attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    //Place Button
    NSLayoutConstraint *centerButton = [NSLayoutConstraint constraintWithItem:_buyAllButton  attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vButton = [NSLayoutConstraint constraintWithItem:_buyAllButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeTop multiplier:1.0f constant:130.0f];
    
    //Place Labels
    NSArray *vButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_buyAllButton]-(-64)-[_bestOfferLabel(==10)]-28-[_buyAllPriceLabel(==10)]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:headerViews];
    
    [self.constraints addObjectsFromArray:hSignConstraints];
    [self.constraints addObjectsFromArray:vSignConstraints];
    [self.constraints addObjectsFromArray:vButtonConstraints]; 
    [self.constraints addObjectsFromArray:@[centerSign,centerButton,vButton]];
    
    [self addConstraints:self.constraints]; 
  }
}

#pragma mark Factory Methods
- (UIImageView *)newSign{
  UIImageView *sign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hobnob_store_titlesign"]];
  [sign setTranslatesAutoresizingMaskIntoConstraints:NO];
  return sign;
}

- (UIButton *)newBuyAllButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"hobnob_store_buyall_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setHidden:YES]; 
  return button;
}


- (UILabel *)newLabelWithText:(NSString *)text{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:9.0f style:Regular]];
  [label setTextColor:[UIColor colorWithWhite:1.0f alpha:.9f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentCenter];
  //todo get price from store
  [label setText:text];
  return label;
}




@end