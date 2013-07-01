
#import "QICheckAnswersView.h"
#import "QIFontProvider.h"

@interface QICheckAnswersView ()

@property(nonatomic, strong) UILabel *resultLabel;
@property(nonatomic, strong) UIView *resultView;
@property(nonatomic, strong) UIImageView *backgroundImage; 
@property(nonatomic, strong) NSMutableArray *checkAnswersViewConstraints;
@property(nonatomic, strong) NSMutableArray *resultViewConstraints;

@end

@implementation QICheckAnswersView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _backgroundImage = [self newBackgroundImage];
      _resultView = [self newResultView];
      _resultLabel = [self newResultLabel];
      _continueButton = [self newContinueButton];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark Properties

- (void)setContinueButton:(UIButton *)continueButton{
  if ([continueButton isEqual:_continueButton]) {
    return;
  }
  _continueButton = continueButton;
}


#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self.resultView addSubview:self.resultLabel];
  [self addSubview:self.backgroundImage];
  [self addSubview:self.resultView];
  [self addSubview:self.continueButton];
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.checkAnswersViewConstraints) {
    
    //Constrain Background Image
    NSDictionary *backgroundImageViews = NSDictionaryOfVariableBindings(_backgroundImage);
    NSArray *hBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageViews];
     NSArray *vBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageViews];
    
    [self.checkAnswersViewConstraints addObjectsFromArray:hBackground];
    [self.checkAnswersViewConstraints addObjectsFromArray:vBackground];
    
    //Check Answer View Constraints
    self.checkAnswersViewConstraints = [NSMutableArray array];
    NSDictionary *checkAnswerViews = NSDictionaryOfVariableBindings(_resultView, _continueButton);
    
    NSArray *hButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_continueButton(==108)]-18-|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *hResultConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_resultView]|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *vResultConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_continueButton(==25)]-9-[_resultView]|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    
    [self.checkAnswersViewConstraints addObjectsFromArray:hButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:hResultConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vResultConstraints];
    
    [self addConstraints:self.checkAnswersViewConstraints];
    
    //Result View Constraints
    self.resultViewConstraints = [NSMutableArray array];
    NSDictionary *resultViews = NSDictionaryOfVariableBindings(_resultLabel);
    
    NSLayoutConstraint *hCenterLabel = [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_resultView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vCenterLabel = [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_resultView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    [self.resultViewConstraints addObjectsFromArray:@[hCenterLabel,vCenterLabel]];
    
    [_resultView addConstraints:self.resultViewConstraints];

  }
}

#pragma mark Actions


#pragma mark Strings
- (NSString *)continueButtonText{
  return @"Check Answers";
}

- (NSString *)resultText{
  return @"CORRECT";
}


#pragma mark Factory Methods

-(UIView *)newBackgroundImage{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_navbar_correct"]];
  [imageView setContentMode:UIViewContentModeScaleToFill];
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imageView;
}
- (UIView *)newResultView{
  UIView *view = [[UIView alloc] init];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [view setBackgroundColor:[UIColor clearColor]];
  return view;
}

- (UILabel *)newResultLabel {
  UILabel *resultLabel = [[UILabel alloc] init];
  [resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [resultLabel setBackgroundColor:[UIColor clearColor]];
  [resultLabel setFont:[QIFontProvider fontWithSize:12.0f style:Regular]];
  [resultLabel setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0f]];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  [resultLabel setText:[self resultText]];
  return resultLabel;
}

- (UIButton *)newContinueButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self continueButtonText] forState:UIControlStateNormal];
  //[nextQuestionButton setBackgroundImage:[[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 74, 0, 74)] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_command_forward_btn"] forState:UIControlStateNormal];
  
  [button.titleLabel setFont:[QIFontProvider fontWithSize:14.0f style:Regular]];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}


@end