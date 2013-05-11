#import "QIMultipleChoiceQuizView.h"
#import "AsyncImageView.h"

@interface QIMultipleChoiceQuizView ()
// TODO(rcacheaux): Encapsulate into own view.
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, strong) UIProgressView *progressView;
@property(nonatomic, strong) UIButton *exitButton;
@property(nonatomic, strong) AsyncImageView *profileImageView;
@property(nonatomic, strong) UILabel *questionLabel;
@property(nonatomic, strong) NSArray *answerButtons;
@property(nonatomic, strong) UIButton *nextQuestionButton;
@property(nonatomic, strong) NSMutableArray *progressViewConstraints;
@property(nonatomic, strong) NSMutableArray *multipleChoiceConstraints; 
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
    
    //TODO rkuhlman not sure if this shoudl stay here. 
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
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
//  self.profileImageView.frame = CGRectMake(80.0f, 60.0f, 100.0f, 150.0f);
//  self.questionLabel.frame = CGRectMake(0.0f, 180.0f, 320.0f, 40.0f);
//  self.nextQuestionButton.frame = CGRectMake(440.0f, 200.0f, 100.0f, 44.0f);
}


- (void)updateConstraints {
  [super updateConstraints];
  
  // --------------TODO rkuhlman : This probably doesn't go here.-----------

  NSDictionary *selfConstraintView =NSDictionaryOfVariableBindings(self);
  
  NSArray *hSelf =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                          options:NSLayoutFormatAlignAllBaseline
                                          metrics:nil
                                            views:selfConstraintView];
  
  NSArray *vSelf =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|"
                                          options:0
                                          metrics:nil
                                            views:selfConstraintView];
  
  NSMutableArray *selfConstraints = [NSMutableArray array];
  [selfConstraints addObjectsFromArray:hSelf];
  [selfConstraints addObjectsFromArray:vSelf];
  [self.superview addConstraints:selfConstraints];
  //---------------  end doesn't go here -----------------------
  
  
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
    
    //Multiple Choice View
    self.multipleChoiceConstraints = [NSMutableArray array];
    NSDictionary *multipleChoiceViews = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _profileImageView,   @"_profileImageView",
                                         _questionLabel,      @"_questionLabel",
                                         _nextQuestionButton, @"_nextQuestionButton",
                                         _answerButtons[0],   @"_answerButtons0",
                                         _answerButtons[1],   @"_answerButtons1",
                                         _answerButtons[2],   @"_answerButtons2",
                                         _answerButtons[3],   @"_answerButtons3",
                                         nil];
    
    NSLayoutConstraint *centerImageX = [NSLayoutConstraint constraintWithItem:_profileImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *imageWidth = [NSLayoutConstraint constraintWithItem:_profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0];
    
    NSLayoutConstraint *centerQuestionX = [NSLayoutConstraint constraintWithItem:_questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
   
    NSMutableArray *choiceButtonConstraints = [NSMutableArray array];
    for (UIButton *button in self.answerButtons){
      [choiceButtonConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [choiceButtonConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200.0f]];
    }
    
    NSLayoutConstraint *hNextButton = [NSLayoutConstraint constraintWithItem:_nextQuestionButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-20.0f];
    
    NSString *quizChoiceVertical = @"V:|-50-[_profileImageView(==120)]-[_questionLabel]-[_answerButtons0]-[_answerButtons1(==_answerButtons0)]-[_answerButtons2(==_answerButtons0)]-[_answerButtons3(==_answerButtons0)]-[_nextQuestionButton]-|";
    NSArray *quizChoiceVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:quizChoiceVertical
                                            options:0
                                            metrics:nil
                                              views:multipleChoiceViews];
    
    [self.multipleChoiceConstraints addObjectsFromArray:@[centerImageX,imageWidth,centerQuestionX,hNextButton]];
    [self.multipleChoiceConstraints addObjectsFromArray:choiceButtonConstraints];
    [self.multipleChoiceConstraints addObjectsFromArray:quizChoiceVerticalConstraints];
    [self addConstraints:self.multipleChoiceConstraints];
    
  }
}

#pragma mark Strings

- (NSString *)exitButtonText {
  return @"x";
}

- (NSString *)nextQuestionButtonText {
  return @"Next Question >";
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

- (AsyncImageView *)newProfileImageView {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  //profileImageView.image = [UIImage imageNamed:@"placeholderHead"];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.imageURL = [NSURL URLWithString:@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-1GoRs4ppiKY3Ta53ROlRJPt6osaXKdBTflGKXf0fT3XT433d"];
  return profileImageView;
}

- (UILabel *)newQuestionLabel {
  UILabel *questionLabel = [[UILabel alloc] init];
  questionLabel.textAlignment = NSTextAlignmentCenter;
  [questionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return questionLabel;
}

- (UIButton *)newAnswerButtonWithTitle:(NSString *)title {
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [answerButton setTitle:title forState:UIControlStateNormal];
  [answerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerButton;
}

- (UIButton *)newNextQuestionButton {
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [nextQuestionButton setTitle:[self nextQuestionButtonText] forState:UIControlStateNormal];
  [nextQuestionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return nextQuestionButton;
}


@end
