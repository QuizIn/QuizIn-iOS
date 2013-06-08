#import "QIMatchingQuizView.h"
#import "AsyncImageView.h"
#import "QIFontProvider.h"

@interface QIMatchingQuizView ()

@property(nonatomic, strong) UIImageView *viewBackground;
@property(nonatomic, strong) UIImageView *divider;
@property(nonatomic, strong) UIView *questionView;
@property(nonatomic, strong) NSArray *questionButtons;
@property(nonatomic, strong) NSArray *questionButtonImages;
@property(nonatomic, strong) NSMutableArray *questionColorImages;
@property(nonatomic, strong) NSArray *questionButtonTapes;
@property(nonatomic, strong) UIView *answerView;
@property(nonatomic, strong) NSArray *answerButtons;
@property(nonatomic, strong) NSMutableArray *answerColorImages;
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
    
    _viewBackground = [self newViewBackground];
    _divider = [self newDivider];
    _progressView = [self newProgressView];
    _questionView = [self newQuestionView];
    _answerView = [self newAnswerView];
    _answerButtons = @[];
    _questionButtons = @[];
    _questionButtonImages = @[];
    _questionButtonTapes = @[];
    _questionColorImages = [self newQuestionColorImages];
    _answerColorImages = [self newAnswerColorImages];
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
  [self addSubview:_viewBackground];
  [self addSubview:_divider];
  [self addSubview:_progressView];
  [self addSubview:_answerView];
  [self addSubview:_questionView];
  [self loadQuestionButtons];
  [self loadAnswerButtons];
  [self addSubview:self.nextQuestionButton];
}

- (void)loadQuestionButtons{
  int i=0;
  for (UIButton *button in self.questionButtons) {
    [button addSubview:_questionButtonImages[i]];
    [_questionView addSubview:button];
    [_questionView addSubview:_questionButtonTapes[i]];
    i++;
  }
}

- (void)loadAnswerButtons{
  for (UIButton *button in self.answerButtons) {
    [_answerView addSubview:button];
  }
}


#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.questionConstraints) {
   
    //Constrain Self
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
    
    //Constrain Background
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    NSMutableArray *backgroundConstraints = [NSMutableArray array];
    [backgroundConstraints addObjectsFromArray:hBackgroundContraints];
    [backgroundConstraints addObjectsFromArray:vBackgroundContraints];
    [self addConstraints:backgroundConstraints];
    
    //Constrain Progress View
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
    
    //Constrain Question and Answer Container Views
    self.questionConstraints = [NSMutableArray array];
    self.answerConstraints = [NSMutableArray array];
    
    NSDictionary *questionAnswerViews = NSDictionaryOfVariableBindings(_progressView,_questionView,_answerView,_divider);
    
    
    NSString *hAnswerView = @"H:|[_answerView]|";
    NSArray *hAnswerViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hAnswerView
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:questionAnswerViews];
    
    [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_questionView attribute:NSLayoutAttributeTop multiplier:1.0f constant:10.0f]];
    
    NSString *vQuestionAnswerView = @"V:[_questionView(<=240)]-2-[_divider(==2)][_answerView(>=220)]|";
    NSArray *vQuestionAnswerViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vQuestionAnswerView
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:questionAnswerViews];
    
    [self.answerConstraints addObjectsFromArray:hAnswerViewConstraints];
    [self.answerConstraints addObjectsFromArray:vQuestionAnswerViewConstraints];
   
    //Constrain Question View
    NSDictionary *questionButtonViews = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _progressView,             @"_progressView",
                                         _questionButtons[0],       @"_questionButtons0",
                                         _questionButtons[1],       @"_questionButtons1",
                                         _questionButtons[2],       @"_questionButtons2",
                                         _questionButtons[3],       @"_questionButtons3",
                                         nil];
    
    for (int i=0;i<[_questionButtonImages count];i++){
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonImages[i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_questionButtons[i] attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonImages[i] attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_questionButtons[i] attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonImages[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_questionButtons[i] attribute:NSLayoutAttributeWidth multiplier:0.795f constant:0.0f]];
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonImages[i] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_questionButtons[i] attribute:NSLayoutAttributeHeight multiplier:0.795f constant:0.0f]];
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonTapes[i] attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_questionButtons[i] attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonTapes[i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButtons[i] attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonTapes[i] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_questionButtonImages[i] attribute:NSLayoutAttributeTop multiplier:1.0f constant:5.0f]];
    }

    for (UIButton *button in self.questionButtons){
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    }
    
    [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtons[0] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0.0f]];
    
    [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtons[0] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_questionView attribute:NSLayoutAttributeHeight multiplier:0.5f constant:0.0f]];
   
    NSString *vTopLeftQuestionButtonsView = @"V:|[_questionButtons0][_questionButtons2(==_questionButtons0)]|";
    NSArray *vTopLeftQuestionButtonsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vTopLeftQuestionButtonsView
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:questionButtonViews];
    
    NSString *vTopRightQuestionButtonsView = @"V:|[_questionButtons1(==_questionButtons0)][_questionButtons3(==_questionButtons0)]|";
    NSArray *vTopRightQuestionButtonsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vTopRightQuestionButtonsView
                                            options:NSLayoutFormatAlignAllRight
                                            metrics:nil
                                              views:questionButtonViews];
    
    NSString *hTopLeftQuestionButtonsView = @"H:|[_questionButtons0][_questionButtons1(==_questionButtons0)]|";
    NSArray *hTopLeftQuestionButtonsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hTopLeftQuestionButtonsView
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:questionButtonViews];
    
    NSString *hBottomLeftQuestionButtonsView = @"H:|[_questionButtons2(==_questionButtons0)][_questionButtons3(==_questionButtons0)]|";
    NSArray *hBottomLeftQuestionButtonsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hBottomLeftQuestionButtonsView
                                            options:NSLayoutFormatAlignAllBottom
                                            metrics:nil
                                              views:questionButtonViews];
    
    [self.questionConstraints addObjectsFromArray:vTopLeftQuestionButtonsConstraints];
    [self.questionConstraints addObjectsFromArray:vTopRightQuestionButtonsConstraints];
    [self.questionConstraints addObjectsFromArray:hTopLeftQuestionButtonsConstraints];
    [self.questionConstraints addObjectsFromArray:hBottomLeftQuestionButtonsConstraints];

    
    //Constrain Answer View
    NSDictionary *answerButtonViews = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _answerButtons[0],   @"_answerButtons0",
                                         _answerButtons[1],   @"_answerButtons1",
                                         _answerButtons[2],   @"_answerButtons2",
                                         _answerButtons[3],   @"_answerButtons3",
                                         _nextQuestionButton, @"_nextQuestionButton",
                                         nil];

    for (UIButton *button in self.answerButtons){
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250.0f]];
    }
    
    NSString *vAnswerButtonsView = @"V:|[_answerButtons0(==_answerButtons0)][_answerButtons1(==_answerButtons0)][_answerButtons2(==_answerButtons0)][_answerButtons3(==_answerButtons0)][_nextQuestionButton]";
    
    NSArray *vAnswerButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vAnswerButtonsView
                                            options:0
                                            metrics:nil
                                              views:answerButtonViews];
    
    [self.answerConstraints addObjectsFromArray:vAnswerButtonConstraints];
    
    //Constrian Next Buttong
    NSArray *vNextButtonConstraint =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_nextQuestionButton(==40)]-3-|"
                                            options:0
                                            metrics:nil
                                              views:answerButtonViews];

    NSLayoutConstraint *hNextButton = [NSLayoutConstraint constraintWithItem:_nextQuestionButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    
    NSLayoutConstraint *nextButtonWidth = [NSLayoutConstraint constraintWithItem:_nextQuestionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:125.0f];
    
    [self.answerConstraints addObjectsFromArray:vNextButtonConstraint];
    [self.answerConstraints addObjectsFromArray:@[hNextButton,nextButtonWidth]];

    [self addConstraints:self.progressViewConstraints];
    [self addConstraints:self.answerConstraints];
    [self addConstraints:self.questionConstraints];
  }
}

#pragma mark Strings
- (NSString *)nextQuestionButtonText {
  return @"Next Question";
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
  NSMutableArray *questionButtonImages = [NSMutableArray arrayWithCapacity:[self.questions count]];
  NSMutableArray *questionButtonTapes = [NSMutableArray arrayWithCapacity:[self.questions count]];
  
  for (NSString *questions in self.questions) {
    UIButton *questionButton = [self newQuestionButton];
    [questionButtons addObject:questionButton];
    AsyncImageView *questionImage = [self newQuestionButtonImage];
    [questionButtonImages addObject:questionImage];
    UIImageView *tape = [self newQuestionButtonTape];
    [questionButtonTapes addObject:tape];
  }
  
  _questionButtonImages = [questionButtonImages copy];
  _questionButtonTapes = [questionButtonTapes copy];
  self.questionButtons = [questionButtons copy];

  return;
}

-(UIImage *)dequeueQuestionColorImage{
  UIImage *lastImage = [self.questionColorImages lastObject];
  [self.questionColorImages removeLastObject];
  return lastImage;
}

-(UIImage *)dequeueAnswerColorImage{
  UIImage *lastImage = [self.answerColorImages lastObject];
  [self.answerColorImages removeLastObject];
  return lastImage;
}

- (void)questionButtonPressed:(id)sender{
  UIButton *pressedButton = (UIButton *)sender;
  UIImage *questionColorImage = [self dequeueQuestionColorImage];
  [pressedButton setBackgroundImage:questionColorImage forState:UIControlStateSelected];
  [pressedButton setBackgroundImage:questionColorImage forState:UIControlStateSelected | UIControlStateHighlighted];
  pressedButton.selected = YES;
}
- (void)answerButtonPressed:(id)sender{
  UIButton *pressedButton = (UIButton *)sender;
  UIImage *answerColorImage = [self dequeueAnswerColorImage];
  [pressedButton setBackgroundImage:answerColorImage forState:UIControlStateSelected];
  [pressedButton setBackgroundImage:answerColorImage forState:UIControlStateSelected | UIControlStateHighlighted];
    pressedButton.selected = YES;
}

#pragma mark Factory Methods
- (QIProgressView *)newProgressView{
  QIProgressView *progressView = [[QIProgressView alloc] init];
  [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
  progressView.numberOfQuestions = _numberOfQuestions;
  progressView.quizProgress = _quizProgress;
  return progressView;
}

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UIView *)newQuestionView{
  UIView *questionView = [[UIView alloc] init];
  [questionView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return questionView;
}

- (UIView *)newAnswerView{
  UIView *answerView = [[UIView alloc] init];
  [answerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerView;
}

- (UIImageView *)newDivider{
  UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_divider"]];
  [divider setTranslatesAutoresizingMaskIntoConstraints:NO];
  return divider;
}

- (UIButton *)newQuestionButton{
  UIButton *questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [questionButton setBackgroundImage:[UIImage imageNamed:@"match_pictureholder"] forState:UIControlStateNormal];
  [questionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [questionButton addTarget:self action:@selector(questionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  return questionButton;
}

- (AsyncImageView *)newQuestionButtonImage{
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  //profileImageView.imageURL = [NSURL URLWithString:@"http://www.awesomeannie.com/annie-wersching-pictures/cache/misc/headshots/annie-wersching-blonde-headshot-01_144_cw144_ch144_thumb.jpg"];
  profileImageView.imageURL = [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"];
  return profileImageView;
}

- (UIImageView *)newQuestionButtonTape{
  UIImageView *profileTape = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiplechoice_tape"]];
  [profileTape setContentMode:UIViewContentModeScaleToFill];
  [profileTape setTranslatesAutoresizingMaskIntoConstraints:NO];
  return profileTape;
}

-(NSMutableArray *)newQuestionColorImages{
  UIEdgeInsets insets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
  return [NSMutableArray arrayWithObjects:
          [UIImage imageNamed:@"match_pictureholder_blue"],
          [UIImage imageNamed:@"match_pictureholder_green"],
          [UIImage imageNamed:@"match_pictureholder_red"],
          [UIImage imageNamed:@"match_pictureholder_yellow"],
          nil];
}

-(NSMutableArray *)newAnswerColorImages{
  UIEdgeInsets insets = UIEdgeInsetsMake(15.0f, 18.0f, 15.0f, 18.0f);
  return [NSMutableArray arrayWithObjects:
          [[UIImage imageNamed:@"match_answerbox_blue"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_answerbox_green"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_answerbox_red"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_answerbox_yellow"] resizableImageWithCapInsets:insets],
          nil];
}

- (UIButton *)newAnswerButtonWithTitle:(NSString *)title {
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [answerButton setTitle:title forState:UIControlStateNormal];
  answerButton.titleLabel.font = [QIFontProvider fontWithSize:16.0f style:Bold];
  answerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  answerButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
  [answerButton setBackgroundImage:[[UIImage imageNamed:@"match_answerbox_std"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 18.0f, 15.0f, 18.0f)]  forState:UIControlStateNormal];
  [answerButton setTitleColor:[UIColor colorWithWhite:0.33f alpha:1.0f] forState:UIControlStateNormal];
  [answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [answerButton setTitleEdgeInsets:UIEdgeInsetsMake(15.0f, 18.0f, 15.0f, 18.0f)];
  [answerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answerButton setAdjustsImageWhenHighlighted:NO];
  [answerButton setReversesTitleShadowWhenHighlighted:NO];
  [answerButton addTarget:self action:@selector(answerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  return answerButton;
}

-(UIButton *)newNextQuestionButton;{
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [nextQuestionButton setTitle:[self nextQuestionButtonText] forState:UIControlStateNormal];
  [nextQuestionButton setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] forState:UIControlStateNormal];
  [nextQuestionButton.titleLabel setFont:[QIFontProvider fontWithSize:14.0f style:Regular]];
  [nextQuestionButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [nextQuestionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return nextQuestionButton;
}



@end






