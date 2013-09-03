
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
      [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:.5f]];
      
      _viewBackground = [self newViewBackground];
      _buyButton = [self newBuyButton];
      _exitButton = [self newExitButton]; 
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void) constructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.buyButton];
  [self addSubview:self.exitButton]; 
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraints) {
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground, _buyButton, _exitButton);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *hButtonContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_buyButton]-40-|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vButtonContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_buyButton]-40-|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *hExitButtonContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_exitButton]-10-|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vExitButtonContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_exitButton]"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    self.constraints = [NSMutableArray array];
    [self.constraints addObjectsFromArray:hBackgroundContraints];
    [self.constraints addObjectsFromArray:vBackgroundContraints];
    [self.constraints addObjectsFromArray:hButtonContraints];
    [self.constraints addObjectsFromArray:vButtonContraints];
    [self.constraints addObjectsFromArray:hExitButtonContraints];
    [self.constraints addObjectsFromArray:vExitButtonContraints];
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

- (UIButton *)newExitButton {
  UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [exitButton setImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateNormal];
  [exitButton setAlpha:0.8f];
  [exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return exitButton;
}

@end
