
#import "QIStoreTableHeaderView.h"
#import "QIFontProvider.h"

@interface QIStoreTableHeaderView ()

@property (nonatomic, strong) UIImageView *sign; 

@property (nonatomic, strong) NSMutableArray *constraints;

@end
@implementation QIStoreTableHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _sign = [self newSign];
      _buyAllButton = [self newBuyAllButton]; 
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.sign];
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
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sign(==112)]"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    NSLayoutConstraint *centerSign = [NSLayoutConstraint constraintWithItem:_sign attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    //Place Button
    NSLayoutConstraint *centerButton = [NSLayoutConstraint constraintWithItem:_buyAllButton  attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vButton = [NSLayoutConstraint constraintWithItem:_buyAllButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_sign attribute:NSLayoutAttributeTop multiplier:1.0f constant:118.0f];
    
    [self.constraints addObjectsFromArray:hSignConstraints];
    [self.constraints addObjectsFromArray:vSignConstraints];
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



@end
