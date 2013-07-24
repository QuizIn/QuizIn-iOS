
#import "QICheckAnswersView.h"
#import "QIFontProvider.h"

@interface QICheckAnswersView ()

@property(nonatomic, strong) UILabel *resultLabel;
@property(nonatomic, strong) UIView *resultView;
@property(nonatomic, strong,) UIImageView *backgroundImage;
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
      _checkButton = [self newCheckButton];
      _helpButton = [self newHelpButton];
      _againButton = [self newAgainButton];
      _nextButton = [self newNextButton];
      _resultHideButton = [self newResultHideButton];
      _seeProfilesButton = [self newSeeProfilesButton];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark Properties

- (void)setCheckButton:(UIButton *)checkButton{
  if ([checkButton isEqual:_checkButton]) {
    return;
  }
  _checkButton = checkButton;
}


#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self.resultView addSubview:self.resultLabel];
  [self.resultView addSubview:self.seeProfilesButton];
  [self addSubview:self.backgroundImage];
  [self addSubview:self.resultView];
  [self addSubview:self.helpButton];
  [self addSubview:self.resultHideButton];
  [self addSubview:self.checkButton];
  [self addSubview:self.againButton];
  [self addSubview:self.nextButton];
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
    NSDictionary *checkAnswerViews = NSDictionaryOfVariableBindings(_resultView, _checkButton, _helpButton, _againButton);
    
    NSArray *hHelpButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_helpButton(==28)]"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    
    NSArray *vHelpButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-6-[_helpButton(==30)]"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *hCheckButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_againButton(==108)]-10-[_checkButton(==108)]-18-|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *hResultConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_resultView]|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *vResultConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_checkButton(==25)]-9-[_resultView]|"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    NSArray *vAgainButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[_againButton(==25)]"
                                            options:0
                                            metrics:nil
                                              views:checkAnswerViews];
    //Overlay the Next Button
    NSLayoutConstraint *hCenterNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCenterNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightNextButton = [NSLayoutConstraint constraintWithItem:_nextButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_checkButton attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];

    //Overlay the Result Hide Button
    NSLayoutConstraint *hCenterHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCenterHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightHideButton = [NSLayoutConstraint constraintWithItem:_resultHideButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_helpButton attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    [self.checkAnswersViewConstraints addObjectsFromArray:@[hCenterHideButton,vCenterHideButton,widthHideButton,heightHideButton]];
    [self.checkAnswersViewConstraints addObjectsFromArray:@[hCenterNextButton,vCenterNextButton,widthNextButton,heightNextButton]];
    [self.checkAnswersViewConstraints addObjectsFromArray:hHelpButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vHelpButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:hCheckButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vAgainButtonConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:hResultConstraints];
    [self.checkAnswersViewConstraints addObjectsFromArray:vResultConstraints];
    
    [self addConstraints:self.checkAnswersViewConstraints];
    
    //Result View Constraints
    self.resultViewConstraints = [NSMutableArray array];
    
    NSDictionary *resultsViews = NSDictionaryOfVariableBindings(_seeProfilesButton);
    
    NSLayoutConstraint *hCenterLabel = [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_resultView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCenterLabel = [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_resultView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSArray *hProfileButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_seeProfilesButton(==28)]"
                                            options:0
                                            metrics:nil
                                              views:resultsViews];
    NSArray *vProfileButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-4-[_seeProfilesButton(==30)]"
                                            options:0
                                            metrics:nil
                                              views:resultsViews];

    [self.resultViewConstraints addObjectsFromArray:@[hCenterLabel,vCenterLabel]];
    [self.resultViewConstraints addObjectsFromArray:hProfileButtonConstraints];
    [self.resultViewConstraints addObjectsFromArray:vProfileButtonConstraints];
    
    [_resultView addConstraints:self.resultViewConstraints];
  }
}

#pragma mark Actions
-(void)correct:(BOOL)correct{
  if(correct){
    [self.againButton setHidden:YES];
    [self.backgroundImage setImage:[UIImage imageNamed:@"quizin_navbar_correct"]];
    [self.resultLabel setText:[self resultCorrectText]];
  }
  else {
    [self.backgroundImage setImage:[UIImage imageNamed:@"quizin_navbar_incorrect"]];
    [self.resultLabel setText:[self resultIncorrectText]];
    [self.againButton setHidden:NO];
  }
}

#pragma mark Strings
- (NSString *)checkButtonText{
  return @"Check Answer";
}
- (NSString *)nextButtonText{
  return @"Continue";
}
- (NSString *)againButtonText{
  return @"Try Again";
}
- (NSString *)resultCorrectText{
  return @"CORRECT";
}
- (NSString *)resultIncorrectText{
  return @"INCORRECT";
}


#pragma mark Factory Methods

-(UIImageView *)newBackgroundImage{
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
  [resultLabel setFont:[QIFontProvider fontWithSize:20.0f style:Regular]];
  [resultLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  return resultLabel;
}

- (UIButton *)newCheckButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self checkButtonText] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_command_up_btn"] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Regular]];
  [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
  [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
  [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 7.0f, 0.0f, 0.0f)];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}
- (UIButton *)newNextButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self nextButtonText] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_command_forward_btn"] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Regular]];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setHidden:YES];
  return button;
}
- (UIButton *)newAgainButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self againButtonText] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_command_std_btn"] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Regular]];
  [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setHidden:YES];
  return button;
}
- (UIButton *)newHelpButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_information_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

- (UIButton *)newResultHideButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_stretch_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setHidden:YES];
  return button;
}

- (UIButton *)newSeeProfilesButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_information_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

@end