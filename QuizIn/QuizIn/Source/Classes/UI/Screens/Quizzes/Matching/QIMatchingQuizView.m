#import "QIMatchingQuizView.h"
#import "AsyncImageView.h"

@interface QIMatchingQuizView ()

@property(nonatomic, strong) NSArray *questionButtons;
@property(nonatomic, strong) NSArray *answerButtons;
@property(nonatomic, strong) UIButton *nextQuestionButton;

@property(nonatomic, strong) NSMutableArray *progressViewConstraints;
@property(nonatomic, strong) NSMutableArray *questionConstraints;
@property(nonatomic, strong) NSMutableArray *answerConstraints;

@end


@implementation QIMatchingQuizView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    _progressView = [self newProgressView];
    _answerButtons = @[];
    _questionButtons = @[];
    _nextQuestionButton = [self newNextQuestionButton];
    
    //TODO rkuhlman not sure if this should stay here.
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self constructViewHierarchy];
  }
  return self;
}


#pragma mark Properties

 
- (void)setQuestions:(NSArray *)questions {
  if ([questions isEqualToArray:_questions]) {
    return;
  }
  _questions = [questions copy];;
  [self updateQuestionButtons];
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

- (void)setQuestionButtons:(NSArray *)questionButtons {
  if ([questionButtons isEqualToArray:_answerButtons]) {
    return;
  }
  _questionButtons = questionButtons;
  [self loadQuestionButtons];
}

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
  
  [self addSubview:_progressView];
  [self addSubview:self.nextQuestionButton];
}

- (void)loadAnswerButtons{
  for (UIButton *button in self.answerButtons) {
    [self addSubview:button];
  }
}

- (void)loadQuestionButtons{
  for (UIButton *button in self.questionButtons) {
    [self addSubview:button];
  }
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.questionConstraints) {
    // --------------TODO rkuhlman : This probably doesn't go here.-----------
    
    NSDictionary *selfConstraintView = NSDictionaryOfVariableBindings(self);
    
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
    
    self.progressViewConstraints = [NSMutableArray array];
    
    
    NSDictionary *progressView = NSDictionaryOfVariableBindings(_progressView);
    
    NSString *hProgressView = @"H:|[_progressView]|";
    NSArray *hProgressViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hProgressView
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:progressView];
    
    NSString *vProgressView = @"V:|[_progressView]";
    NSArray *vProgressViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vProgressView
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:progressView];
    
    [self.progressViewConstraints addObjectsFromArray:vProgressViewConstraints];
    [self.progressViewConstraints addObjectsFromArray:hProgressViewConstraints];
    
    
    NSDictionary *buttonViews = [NSDictionary dictionaryWithObjectsAndKeys:
                                 _progressView,         @"_progressView",
                                 _questionButtons[0],   @"_questionButtons0",
                                 _questionButtons[1],   @"_questionButtons1",
                                 _questionButtons[2],   @"_questionButtons2",
                                 _questionButtons[3],   @"_questionButtons3",
                                 _answerButtons[0],   @"_answerButtons0",
                                 _answerButtons[1],   @"_answerButtons1",
                                 _answerButtons[2],   @"_answerButtons2",
                                 _answerButtons[3],   @"_answerButtons3",
                                 _nextQuestionButton, @"_nextQuestionButton",
                                         nil];
    
    self.answerConstraints = [NSMutableArray array];
    
    for (UIButton *button in self.answerButtons){
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250.0f]];
    }
    
    self.questionConstraints = [NSMutableArray array];
    
    for (UIButton *button in self.questionButtons){
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250.0f]];
    }
    
    NSString *vButtonsView = @"V:[_progressView]-[_questionButtons0]-[_questionButtons1(==_questionButtons0)]-[_questionButtons2(==_questionButtons0)]-[_questionButtons3(==_questionButtons0)]-[_answerButtons0(==_questionButtons0)]-[_answerButtons1(==_questionButtons0)]-[_answerButtons2(==_questionButtons0)]-[_answerButtons3(==_questionButtons0)]-[_nextQuestionButton(==_questionButtons0)]-|";
    
    NSArray *vButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vButtonsView
                                            options:0
                                            metrics:nil
                                              views:buttonViews];
    
    [self.questionConstraints addObjectsFromArray:vButtonConstraints];
    
    NSArray *hNextButtonConstraint =
    [NSLayoutConstraint constraintsWithVisualFormat:@"[_nextQuestionButton]-|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:buttonViews];

    
    [self.answerConstraints addObjectsFromArray:hNextButtonConstraint];

    
    [self addConstraints:self.progressViewConstraints];
    [self addConstraints:self.answerConstraints];
    [self addConstraints:self.questionConstraints];
  }
}

#pragma mark Strings
- (NSString *)nextQuestionButtonText {
  return @"Next Question >";
}

#pragma mark Data Display

-(void)updateProgress{
  self.progressView.numberOfQuestions = _numberOfQuestions;
  self.progressView.quizProgress = _quizProgress;
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

- (void)updateQuestionButtons {
  if ([self.questions count] == 0) {
    return;
  }
  NSMutableArray *questionButtons = [NSMutableArray arrayWithCapacity:[self.questions count]];
  for (NSString *questions in self.questions) {
    UIButton *questionButton = [self newQuestionButtonWithTitle:questions];
    [questionButtons addObject:questionButton];
  }
  self.questionButtons = [questionButtons copy];
}

#pragma mark Factory Methods

- (QIProgressView *)newProgressView{
  QIProgressView *progressView = [[QIProgressView alloc] init];
  [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
  progressView.numberOfQuestions = _numberOfQuestions;
  progressView.quizProgress = _quizProgress;
  return progressView;
}

- (AsyncImageView *)newProfileImageView {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  //profileImageView.image = [UIImage imageNamed:@"placeholderHead"];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  //super large test image
  //profileImageView.imageURL = [NSURL URLWithString:@"http://cdn.urbanislandz.com/wp-content/uploads/2011/10/MMSposter-large.jpg"];
  // rick image (realiztic size)
  profileImageView.imageURL = [NSURL URLWithString:@"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-1GoRs4ppiKY3Ta53ROlRJPt6osaXKdBTflGKXf0fT3XT433d"];
  return profileImageView;
}
- (UIButton *)newQuestionButtonWithTitle:(NSString *)title {
  UIButton *questionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [questionButton setTitle:title forState:UIControlStateNormal];
  [questionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return questionButton;
}

- (UIButton *)newAnswerButtonWithTitle:(NSString *)title {
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [answerButton setTitle:title forState:UIControlStateNormal];
  [answerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerButton;
}

-(UIButton *)newNextQuestionButton;{
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [nextQuestionButton setTitle:[self nextQuestionButtonText] forState:UIControlStateNormal];
  [nextQuestionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return nextQuestionButton;
}

@end





