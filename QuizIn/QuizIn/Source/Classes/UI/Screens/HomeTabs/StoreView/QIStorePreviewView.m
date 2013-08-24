
#import "QIStorePreviewView.h"

@interface QIStorePreviewView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *constraints;

@end
@implementation QIStorePreviewView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      [self setBackgroundColor:[UIColor colorWithWhite:.5f alpha:.3f]];
      
      _viewBackground = [self newViewBackground];
      _buyButton = [self newBuyButton];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void) constructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.buyButton];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraints) {
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-50-[_viewBackground]-50-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-50-[_viewBackground]-50-|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    self.constraints = [NSMutableArray array];
    [self.constraints addObjectsFromArray:hBackgroundContraints];
    [self.constraints addObjectsFromArray:vBackgroundContraints];
    [self addConstraints:self.constraints]; 
  }
}


#pragma mark Factory Methods
- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UIButton *)newBuyButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"store_purchasel_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}


@end
