
#import "QIProgressView.h"

@interface QIProgressView ()

@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong,readwrite) UIButton *exitButton;
@property(nonatomic, strong) NSMutableArray *progressViewConstraints;

@end

@implementation QIProgressView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _progressLabel = [self newProgressLabel];
      _progressView = [self newProgressView];
      _exitButton = [self newExitButton];
      //[self setBackgroundColor:[UIColor colorWithWhite:.90f alpha:1.0]];
      [self constructViewHierarchy];
    }
    return self;
}



#pragma mark Properties

- (void)setQuizProgress:(NSUInteger)quizProgress {
  _quizProgress = quizProgress;
  [self updateProgress];
}

- (void)setNumberOfQuestions:(NSUInteger)numberOfQuestions {
  _numberOfQuestions = numberOfQuestions;
  [self updateProgress];
}

- (void)setExitButton:(UIButton *)exitButton{
  if ([exitButton isEqual:_exitButton]) {
    return;
  }
  _exitButton = exitButton;
}

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self addSubview:self.progressLabel];
  [self addSubview:self.progressView];
  [self addSubview:self.exitButton];
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.progressViewConstraints) {
    
    /*NSDictionary *selfConstraintView = NSDictionaryOfVariableBindings(self);
    
    NSArray *hSelf =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:selfConstraintView];
    
    NSArray *vSelf =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self(==31)]"
                                            options:0
                                            metrics:nil
                                              views:selfConstraintView];
     */
    
    NSMutableArray *selfConstraints = [NSMutableArray array];
    //[selfConstraints addObjectsFromArray:hSelf];
    //[selfConstraints addObjectsFromArray:vSelf];
    [self.superview addConstraints:selfConstraints];
    
    //ProgressView Constraints
    self.progressViewConstraints = [NSMutableArray array];
    NSDictionary *quizProgressViews =
    NSDictionaryOfVariableBindings(_progressLabel, _progressView, _exitButton);
    
    NSString *quizProgressHorizontalFromLeft =
    @"H:|-10-[_progressLabel(==28)]-[_progressView]-[_exitButton(==28)]-10-|";
    NSArray *quizProgressHorizontalConstraintsLeft =
    [NSLayoutConstraint constraintsWithVisualFormat:quizProgressHorizontalFromLeft
                                            options:NSLayoutFormatAlignAllCenterY
                                            metrics:nil
                                              views:quizProgressViews];
    
    NSLayoutConstraint *hCenterProgressBar = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vCenterProgressBar = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSString *quizProgressVertical = @"V:[_exitButton(==20)]";
    NSArray *quizProgressVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:quizProgressVertical
                                            options:0
                                            metrics:nil
                                              views:quizProgressViews];
    
    [self.progressViewConstraints addObjectsFromArray:@[hCenterProgressBar,vCenterProgressBar]];
    [self.progressViewConstraints addObjectsFromArray:quizProgressHorizontalConstraintsLeft];
    [self.progressViewConstraints addObjectsFromArray:quizProgressVerticalConstraints];
    [self addConstraints:self.progressViewConstraints];
  }
  
}

#pragma mark Actions

- (void)updateProgress {
  self.progressLabel.text = [NSString stringWithFormat:@"%d/%d",
                             self.quizProgress, self.numberOfQuestions];
  if (self.numberOfQuestions > 0){
    float progressValue = (float)self.quizProgress/(float)self.numberOfQuestions;
    self.progressView.progress = progressValue;
  }
}
 
#pragma mark Strings


#pragma mark Factory Methods

- (UILabel *)newProgressLabel {
  UILabel *progressLabel = [[UILabel alloc] init];
  [progressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [progressLabel setBackgroundColor:[UIColor clearColor]];
  progressLabel.font = [UIFont fontWithName:@"Tahoma-Bold" size:10.0f];
  progressLabel.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  progressLabel.adjustsFontSizeToFitWidth = YES;
  [progressLabel setAdjustsFontSizeToFitWidth:YES];
  return progressLabel;
}

- (UIProgressView *)newProgressView {
  UIProgressView *progressView = [[UIProgressView alloc] init];
  [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];

  UIImage *track = [[UIImage imageNamed:@"progressView_tracker"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 40)];
  UIImage *progress = [[UIImage imageNamed:@"progressView_progress"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 40)];
  
  [progressView setTrackImage:track];
  [progressView setProgressImage:progress];
  [progressView setProgressViewStyle:UIProgressViewStyleDefault];
  return progressView;
}

- (UIButton *)newExitButton {
  UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [exitButton setImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateNormal];
  [exitButton setAlpha:0.8f];
  [exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return exitButton;
}


@end
