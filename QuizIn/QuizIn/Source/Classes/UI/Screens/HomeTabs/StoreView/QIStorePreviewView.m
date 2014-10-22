
#import "QIStorePreviewView.h"

@interface QIStorePreviewView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *constraints;
@property (nonatomic, strong) UIImageView *previewImageView;

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
      _exitButton = [self newExitButton];
      _previewImageView = [self newPreviewImageView];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark Properties
- (void)setPreviewTag:(NSInteger)previewTag{
  _previewTag = previewTag;
  [self updatePreviewImage];
}

#pragma mark View Hierarchy
- (void) constructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.exitButton];
  [self addSubview:self.previewImageView];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraints) {
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground, _exitButton, _previewImageView);
    
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
    NSArray *hExitButtonContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_exitButton(==28)]-10-|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vExitButtonContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_exitButton(==20)]-30-[_previewImageView]"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *hPreviewImageContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_previewImageView]-20-|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    self.constraints = [NSMutableArray array];
    [self.constraints addObjectsFromArray:hBackgroundContraints];
    [self.constraints addObjectsFromArray:vBackgroundContraints];
    [self.constraints addObjectsFromArray:hExitButtonContraints];
    [self.constraints addObjectsFromArray:vExitButtonContraints];
    [self.constraints addObjectsFromArray:hPreviewImageContraints];
    [self addConstraints:self.constraints];
  }
}
#pragma mark Actions
- (void)updatePreviewImage{
  NSString *imageName;
  switch (self.previewTag) {
    case 0:
      imageName = @"FilterPreview";
      break;
    case 1:
      imageName = @"QuestionTypesPreview";
      break;
    case 2:
      imageName = @"NeedsRefreshPreview";
      break;
      
    default:
      break;
  }
  [self.previewImageView setImage:[UIImage imageNamed:imageName]];
}

#pragma mark Factory Methods
- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UIButton *)newExitButton {
  UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [exitButton setImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateNormal];
  [exitButton setAlpha:0.8f];
  [exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return exitButton;
}

- (UIImageView *)newPreviewImageView {
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FilterPreview"]];
  [image setContentMode:UIViewContentModeScaleAspectFit];
  [image setTranslatesAutoresizingMaskIntoConstraints:NO];
  return image;
}

@end
