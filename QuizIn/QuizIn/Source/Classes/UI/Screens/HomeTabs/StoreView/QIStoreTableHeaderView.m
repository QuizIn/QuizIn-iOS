
#import "QIStoreTableHeaderView.h"
#import "QIFontProvider.h"

@interface QIStoreTableHeaderView ()

@property (nonatomic, strong) UIImageView *sign;
@property (nonatomic, strong) UILabel *storeLabel; 

@property (nonatomic, strong) NSMutableArray *constraints;

@end
@implementation QIStoreTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _sign = [self newSign];
      _storeLabel = [self newStoreLabel];
      _buyAllButton = [self newBuyAllButton]; 
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.sign];
  [self addSubview:self.storeLabel];
  [self addSubview:self.buyAllButton]; 
}

#pragma mark Constraints
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraints){
    self.constraints = [NSMutableArray array];
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_sign);
    
    //Place Sign
    NSArray *hSignConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sign(==194)]"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSArray *vSignConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_sign(==112)]"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSLayoutConstraint *centerSign = [NSLayoutConstraint constraintWithItem:_sign attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    //Place Label
    NSLayoutConstraint *centerLabel = [NSLayoutConstraint constraintWithItem:_storeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vLabel = [NSLayoutConstraint constraintWithItem:_storeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeTop multiplier:1.0f constant:72.0f];
    
    //Place Button
    NSLayoutConstraint *centerButton = [NSLayoutConstraint constraintWithItem:_buyAllButton  attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vButton = [NSLayoutConstraint constraintWithItem:_buyAllButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeTop multiplier:1.0f constant:118.0f];
    
    [self.constraints addObjectsFromArray:hSignConstraints];
    [self.constraints addObjectsFromArray:vSignConstraints];
    [self.constraints addObjectsFromArray:@[centerSign,centerLabel,vLabel,centerButton,vButton]];
    
    [self addConstraints:self.constraints]; 
  }
}

#pragma mark Factory Methods
- (UIImageView *)newSign{
  UIImageView *sign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_sign"]];
  [sign setTranslatesAutoresizingMaskIntoConstraints:NO];
  return sign;
}

-(UILabel *)newStoreLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]]; 
  [label setText:@"Hobnob Store"];
  [label setFont:[QIFontProvider fontWithSize:14.0f style:Bold]];
  return label; 
}

- (UIButton *)newBuyAllButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"store_buyall_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}



@end
