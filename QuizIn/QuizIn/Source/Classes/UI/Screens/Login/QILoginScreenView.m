
#import "QILoginScreenView.h"
#import "QIFontProvider.h"

@interface QILoginScreenView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic, strong) NSMutableArray *overlayConstraints;
@property (nonatomic, strong) UIScrollView *previewScrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIView *overlayMask;

@end

@implementation QILoginScreenView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewBackground = [self newViewBackground];
      _loginButton = [self newLoginButton];
      _previewScrollView = [self newPreviewScrollView]; 
      _activityView = [self newActivityView];
      _overlayMask = [self newOverlayMask];
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark Properties
- (void)setThinkingIndicator:(BOOL *)thinkingIndicator{
  _thinkingIndicator = thinkingIndicator;
  [self updateActivityView];
}
#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.loginButton];
  [self addSubview:self.previewScrollView];
  [self addSubview:self.overlayMask];
  [self.overlayMask addSubview:self.activityView];
}

#pragma mark Layout
- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.viewConstraints) {
    
    self.viewConstraints = [NSMutableArray array];
    self.overlayConstraints = [NSMutableArray array];
    
    NSDictionary *loginViews = NSDictionaryOfVariableBindings(_viewBackground, _loginButton, _previewScrollView, _overlayMask);
    
    
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
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-[_previewScrollView][_loginButton(==47)]-|"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:loginViews];
    
    [self.viewConstraints addObjectsFromArray:hScrollViewContraints];
    [self.viewConstraints addObjectsFromArray:vScrollViewContraints];

    
    
    //Constrain the login button
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_loginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_loginButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:262.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_loginButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:47.0f]];


    
    //Constrain the overlay Mask
    NSArray *hOverlayContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_overlayMask]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:loginViews];
    NSArray *vOverlayContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_overlayMask]|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:loginViews];
    
    [self.viewConstraints addObjectsFromArray:hOverlayContraints];
    [self.viewConstraints addObjectsFromArray:vOverlayContraints];
    
    [self addConstraints:self.viewConstraints];
    
    [self.overlayConstraints addObject:[NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.overlayMask attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.overlayConstraints addObject:[NSLayoutConstraint constraintWithItem:_activityView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.overlayMask attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self.overlayMask addConstraints:self.overlayConstraints]; 
 

  }
}
#pragma mark Actions
- (void)updateActivityView{
  [self.overlayMask setHidden:!self.thinkingIndicator];
}

#pragma mark Factory Methods
- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UIButton *)newLoginButton{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"login_learn_btn_standard"] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12 style:Bold]];
  [button setTitle:@"Login Through LinkedIn" forState:UIControlStateNormal]; 
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

- (UIView *)newOverlayMask{
  UIView *overlay = [[UIView alloc] init];
  [overlay setHidden:YES];
  [overlay setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:.8f]];
  [overlay setTranslatesAutoresizingMaskIntoConstraints:NO];
  return overlay;
}
- (UIActivityIndicatorView *)newActivityView{
  UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [activity setAlpha:.8f];
  [activity startAnimating];
  [activity setTranslatesAutoresizingMaskIntoConstraints:NO];
  return activity;
}

@end

