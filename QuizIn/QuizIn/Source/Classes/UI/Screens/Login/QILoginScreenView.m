
#import "QILoginScreenView.h"

@interface QILoginScreenView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic, strong) UIScrollView *previewScrollView; 

@end

@implementation QILoginScreenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewBackground = [self newViewBackground];
      _loginButton = [self newLoginButton];
      _previewScrollView = [self newPreviewScrollView]; 
      
      [self constructViewHierarchy]; 
    }
    return self;
}
#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.loginButton];
  [self addSubview:self.previewScrollView]; 
}

#pragma mark Layout
- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.viewConstraints) {
    
    self.viewConstraints = [NSMutableArray array];
    
    NSDictionary *loginViews = NSDictionaryOfVariableBindings(_viewBackground, _loginButton, _previewScrollView);
    
    
    //Constrain the background image
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:loginViews];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:loginViews];
    
    [self.viewConstraints addObjectsFromArray:hBackgroundContraints];
    [self.viewConstraints addObjectsFromArray:vBackgroundContraints];
    
    //Constrain the scroll View
    NSArray *hScrollViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-[_previewScrollView]-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:loginViews];
    NSArray *vScrollViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-[_previewScrollView]-[_loginButton]"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:loginViews];
    
    [self.viewConstraints addObjectsFromArray:hScrollViewContraints];
    [self.viewConstraints addObjectsFromArray:vScrollViewContraints];

    
    
    //Constrain the login button
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_loginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_loginButton attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBaseline multiplier:1.0f constant:-15.0f]];
    
    [self addConstraints:self.viewConstraints]; 

  }
}

#pragma mark Factory Methods
- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UIButton *)newLoginButton{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"login_learn_btn_standard"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

-(UIScrollView *)newPreviewScrollView{
  UIScrollView *previewView = [[UIScrollView alloc] init];
  [previewView setDelegate:self];
  [previewView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [previewView setPagingEnabled:YES];
  [previewView setShowsHorizontalScrollIndicator:NO];
  [previewView setShowsVerticalScrollIndicator:NO];
  [previewView setBouncesZoom:NO];
  [previewView setBounces:YES];
  [previewView setDirectionalLockEnabled:YES];
  [previewView setAlwaysBounceVertical:NO];
  [previewView setAlwaysBounceHorizontal:YES];
  return previewView;
}

@end

