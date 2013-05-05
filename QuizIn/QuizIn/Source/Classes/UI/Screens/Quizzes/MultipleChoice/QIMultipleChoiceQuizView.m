#import "QIMultipleChoiceQuizView.h"

@interface QIMultipleChoiceQuizView ()
// TODO(rcacheaux): Encapsulate into own view.
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UIButton *exitButton;
@property(nonatomic, strong) UIImageView *profileImageView;
@property(nonatomic, strong) UILabel *questionLabel;
@property(nonatomic, strong) NSArray *answerButtons;
@property(nonatomic, strong) UIButton *nextQuestionButton;
@property(nonatomic, strong) NSMutableArray *constraints;
@end

@implementation QIMultipleChoiceQuizView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _question = @"";
    _answers = @[];
    
    _progressLabel = [self newProgressLabel];
    _progressView = [self newProgressView];
    _exitButton = [self newExitButton];
    _profileImageView = [self newProfileImageView];
    _questionLabel = [self newQuestionLabel];
    _answerButtons = @[];
    _nextQuestionButton = [self newNextQuestionButton];
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

- (void)setQuestion:(NSString *)question {
  if ([question isEqualToString:_question]) {
    return;
  }
  _question = question;
  self.questionLabel.text = _question;
}

- (void)setProfileImage:(UIImage *)profileImage {
  if ([profileImage isEqual:_profileImage]) {
    return;
  }
  _profileImage = profileImage;
  self.profileImageView.image = _profileImage;
}

- (void)setAnswers:(NSArray *)answers {
  if ([answers isEqualToArray:_answers]) {
    return;
  }
  _answers = [answers copy];
  [self updateAnswerButtons];
}

- (void)setAnswerButtons:(NSArray *)answerButtons {
  if ([answerButtons isEqualToArray:_answerButtons]) {
    return;
  }
  _answerButtons = answerButtons;
  [self loadAnswerButtons];
}

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self addSubview:self.progressLabel];
  [self addSubview:self.progressView];
  [self addSubview:self.exitButton];
  [self addSubview:self.profileImageView];
  [self addSubview:self.questionLabel];
  [self addSubview:self.nextQuestionButton];
}

- (void)loadAnswerButtons {
  for (UIButton *button in self.answerButtons) {
    [self addSubview:button];
  }
}

#pragma mark Layout


- (void)layoutSubviews {
  [super layoutSubviews];
//  self.progressLabel.frame = CGRectMake(20.0f, 10.0f, 40.0f, 20.0f);
//  self.progressView.frame = CGRectMake(65.0f, 12.0f, 200.0f, 20.0f);
//  self.exitButton.frame = CGRectMake(270.0f, 10.0f, 44.0f, 44.0f);
  self.profileImageView.frame = CGRectMake(80.0f, 60.0f, 100.0f, 150.0f);
  self.questionLabel.frame = CGRectMake(0.0f, 180.0f, 320.0f, 40.0f);
  self.nextQuestionButton.frame = CGRectMake(440.0f, 200.0f, 100.0f, 44.0f);
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraints) {
    self.constraints = [NSMutableArray array];
    /*
    NSLayoutConstraint *centerProgressView =
        [NSLayoutConstraint constraintWithItem:self.progressView
                                     attribute:NSLayoutAttributeCenterX
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeCenterX
                                    multiplier:1.0f
                                      constant:0.0f];*/
    NSString *quizProgressHorizontal =
        @"H:|-30-[_progressLabel]-8-[_progressView]-8-[_exitButton(==44)]-10-|";
    NSDictionary *quizProgressViews =
        NSDictionaryOfVariableBindings(_progressLabel, _progressView, _exitButton);
    NSArray *quizProgressHorizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:quizProgressHorizontal
                                                options:NSLayoutFormatAlignAllCenterY
                                                metrics:nil
                                                  views:quizProgressViews];
    NSString *quizProgressVertical = @"V:|-10-[_exitButton(==44)]";
    NSArray *quizProgressVerticalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:quizProgressVertical
                                                options:0
                                                metrics:nil
                                                  views:quizProgressViews];
    [self.constraints addObjectsFromArray:quizProgressHorizontalConstraints];
    [self.constraints addObjectsFromArray:quizProgressVerticalConstraints];
    [self addConstraints:self.constraints];
  }
}

#pragma mark Strings

- (NSString *)exitButtonText {
  return @"x";
}

#pragma mark Data Display

- (void)updateProgress {
  self.progressLabel.text = [NSString stringWithFormat:@"%d/%d",
                             self.quizProgress, self.numberOfQuestions];
}

- (void)updateAnswerButtons {
  if ([self.answers count] == 0) {
    return;
  }
  NSMutableArray *answerButtons = [NSMutableArray arrayWithCapacity:[self.answers count]];
  for (NSString *answer in self.answers) {
    UIButton *answerButton = [self newAnswerButtonWithTitle:answer];
    [answerButtons addObject:answerButton];
  }
  self.answerButtons = [answerButtons copy];
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

- (UIImageView *)newProfileImageView {
  UIImageView *profileImageView = [[UIImageView alloc] init];
  return profileImageView;
}

- (UILabel *)newQuestionLabel {
  UILabel *questionLabel = [[UILabel alloc] init];
  questionLabel.textAlignment = NSTextAlignmentCenter;
  return questionLabel;
}

- (UIButton *)newAnswerButtonWithTitle:(NSString *)title {
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [answerButton setTitle:title forState:UIControlStateNormal];
  return answerButton;
}

- (UIButton *)newNextQuestionButton {
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  return nextQuestionButton;
}


@end
