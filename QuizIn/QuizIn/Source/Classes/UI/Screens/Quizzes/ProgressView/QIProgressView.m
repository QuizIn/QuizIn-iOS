
#import "QIProgressView.h"

@interface QIProgressView ()

@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong,readwrite) UIButton *exitButton;
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
