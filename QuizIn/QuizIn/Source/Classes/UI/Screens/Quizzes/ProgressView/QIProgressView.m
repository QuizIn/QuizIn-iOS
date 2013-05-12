
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
      
      //TODO rkuhlman
      _quizProgress = 1;
      _numberOfQuestions = 11;
      
      [self constructViewHierarchy];
    }
    return self;
}

- (void)updateProgress {
  self.progressLabel.text = [NSString stringWithFormat:@"%d/%d",
                             self.quizProgress, self.numberOfQuestions];
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
    
    //ProgressView Constraints
    self.progressViewConstraints = [NSMutableArray array];
    NSDictionary *quizProgressViews =
    NSDictionaryOfVariableBindings(_progressLabel, _progressView, _exitButton);
    
    NSString *quizProgressHorizontalFromLeft =
    @"H:|-10-[_progressLabel]-8-[_progressView]-8-[_exitButton(==44)]-10-|";
    NSArray *quizProgressHorizontalConstraintsLeft =
    [NSLayoutConstraint constraintsWithVisualFormat:quizProgressHorizontalFromLeft
                                            options:NSLayoutFormatAlignAllCenterY
                                            metrics:nil
                                              views:quizProgressViews];
    NSLayoutConstraint *centerProgressBar = [NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSString *quizProgressVertical = @"V:|-10-[_exitButton(==44)]";
    NSArray *quizProgressVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:quizProgressVertical
                                            options:0
                                            metrics:nil
                                              views:quizProgressViews];
    [self.progressViewConstraints addObjectsFromArray:@[centerProgressBar]];
    [self.progressViewConstraints addObjectsFromArray:quizProgressHorizontalConstraintsLeft];
    [self.progressViewConstraints addObjectsFromArray:quizProgressVerticalConstraints];
    [self addConstraints:self.progressViewConstraints];
  }
  
}

#pragma mark Strings

- (NSString *)exitButtonText {
  return @"x";
}

#pragma mark Factory Methods

- (UILabel *)newProgressLabel {
  UILabel *progressLabel = [[UILabel alloc] init];
  [progressLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return progressLabel;
}

- (UIProgressView *)newProgressView {
  UIProgressView *progressView = [[UIProgressView alloc] init];
  [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return progressView;
}

- (UIButton *)newExitButton {
  UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [exitButton setTitle:[self exitButtonText] forState:UIControlStateNormal];
  [exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return exitButton;
}


@end
