#import "QIMultipleChoiceQuizView.h"
#import "AsyncImageView.h"
#import "QIFontProvider.h"

@interface QIMultipleChoiceQuizView ()

@property(nonatomic, strong) UIImageView *viewBackground;
@property(nonatomic, strong) UIImageView *dividerTop;
@property(nonatomic, strong) UIImageView *dividerBottom;
@property(nonatomic, strong) UIImageView *profileImageBackground;
@property(nonatomic, strong) UIImageView *profileImageTape;

@property(nonatomic, strong) AsyncImageView *profileImageView;
@property(nonatomic, strong) UILabel *questionLabel;
@property(nonatomic, strong) NSArray *answerButtons;

@property(nonatomic, strong) NSMutableArray *progressViewConstraints;
@property(nonatomic, strong) NSMutableArray *multipleChoiceConstraints;
@property(nonatomic, strong) NSLayoutConstraint *topCheck;
@property(nonatomic, assign) BOOL resultClosed;
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
    
    _viewBackground = [self newViewBackground];
    _dividerTop = [self newDivider];
    _dividerBottom = [self newDivider];
    _profileImageBackground = [self newProfileImageBackground];
    _profileImageTape = [self newProfileImageTape];
    
    _progressView = [self newProgressView];
    _profileImageView = [self newProfileImageView];
    _questionLabel = [self newQuestionLabel];
    _answerButtons = @[];
    _checkAnswersView = [self newCheckAnswersView];
    _resultClosed = YES; 
  
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

- (void)setProfileImageURL:(NSURL *)profileImageURL{
  _profileImageURL = profileImageURL;
  [self updateProfileImage];
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
  [self addSubview:self.viewBackground];
  [self addSubview:self.profileImageBackground];
  [self addSubview:self.profileImageView];
  [self addSubview:self.profileImageTape];
  [self addSubview:self.progressView];
  [self addSubview:self.questionLabel];
  [self addSubview:self.dividerTop];
  [self addSubview:self.dividerBottom];
}

- (void)loadAnswerButtons {
  for (UIButton *button in self.answerButtons) {
    [self addSubview:button];
  }
  //TODO This should not go here, but I am not sure how to get it on top at this point. 
  [self addSubview:self.checkAnswersView];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
    
  if (!self.multipleChoiceConstraints) {
    
    // Constrain Self
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
    
    //Constrain Background Image
    self.multipleChoiceConstraints = [NSMutableArray array];
  
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
    
    [self.multipleChoiceConstraints addObjectsFromArray:hBackgroundContraints];
    [self.multipleChoiceConstraints addObjectsFromArray:vBackgroundContraints];
    
    //Constrain View Elements
    NSDictionary *multipleChoiceViews = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _progressView,       @"_progressView",
                                         _profileImageView,   @"_profileImageView",
                                         _questionLabel,      @"_questionLabel",
                                         _dividerTop,         @"_dividerTop",
                                         _dividerBottom,      @"_dividerBottom",
                                         _answerButtons[0],   @"_answerButtons0",
                                         _answerButtons[1],   @"_answerButtons1",
                                         _answerButtons[2],   @"_answerButtons2",
                                         _answerButtons[3],   @"_answerButtons3",
                                         nil];
    
    NSLayoutConstraint *centerImageX = [NSLayoutConstraint constraintWithItem:_profileImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *imageWidth = [NSLayoutConstraint constraintWithItem:_profileImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:144.0f];
    
    NSLayoutConstraint *centerQuestionX = [NSLayoutConstraint constraintWithItem:_questionLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *centerDividerTopX = [NSLayoutConstraint constraintWithItem:_dividerTop attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *centerDividerBottomX = [NSLayoutConstraint constraintWithItem:_dividerBottom attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_dividerTop attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
   
    NSMutableArray *choiceButtonConstraints = [NSMutableArray array];
    for (UIButton *button in self.answerButtons){
      [choiceButtonConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [choiceButtonConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:283.0f]];
    }
    
    NSString *quizChoiceVertical = @"V:|[_progressView]-3-[_profileImageView(==144)]-(>=15,<=20)-[_dividerTop(==2)][_questionLabel(>=28)][_dividerBottom(==2)]-(>=0,<=8)-[_answerButtons0(>=45,<=60)][_answerButtons1(==_answerButtons0)][_answerButtons2(==_answerButtons0)][_answerButtons3(==_answerButtons0)]-(>=43)-|";
    
    NSArray *quizChoiceVerticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:quizChoiceVertical
                                            options:0
                                            metrics:nil
                                              views:multipleChoiceViews];
    
    [self.multipleChoiceConstraints addObjectsFromArray:@[centerImageX,imageWidth,centerQuestionX,centerDividerTopX,centerDividerBottomX]];
    [self.multipleChoiceConstraints addObjectsFromArray:choiceButtonConstraints];
    [self.multipleChoiceConstraints addObjectsFromArray:quizChoiceVerticalConstraints];
    
    //Constrain Profile Image Holder and tape
    
    NSLayoutConstraint *centerImageBackgroundX = [NSLayoutConstraint constraintWithItem:_profileImageBackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:-1.0f];
    
    NSLayoutConstraint *centerImageBackgroundY = [NSLayoutConstraint constraintWithItem:_profileImageBackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *widthImageBackground = [NSLayoutConstraint constraintWithItem:_profileImageBackground attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:25.0f];
    
    NSLayoutConstraint *heightImageBackground = [NSLayoutConstraint constraintWithItem:_profileImageBackground attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:34.0f];
    
    NSLayoutConstraint *centerTapeX = [NSLayoutConstraint constraintWithItem:_profileImageTape attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *tapeY = [NSLayoutConstraint constraintWithItem:_profileImageTape attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_profileImageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:-11.0f];
    
    [self.multipleChoiceConstraints addObjectsFromArray:@[centerImageBackgroundX,centerImageBackgroundY,widthImageBackground,heightImageBackground,centerTapeX,tapeY]];
    
    //Constrain Check Answers View
    NSLayoutConstraint *centerCheckX = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:81.0f];
    
    _topCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-40.0f];

    [self.multipleChoiceConstraints addObjectsFromArray:@[centerCheckX,widthCheck,heightCheck,_topCheck]];
    [self addConstraints:self.multipleChoiceConstraints];
  }
}

#pragma mark Actions
-(void)checkButtonPressed{
  NSLog(@"checkButton Pressed");
  [self showResult];
}
-(void)againButtonPressed{
  NSLog(@"againButton Pressed");
  [self resetView];
}
-(void)showResult{
  NSLog(@"showResult");
  [UIView animateWithDuration:0.5 animations:^{
    [self.checkAnswersView.nextButton setHidden:NO];
    [self.checkAnswersView.againButton setHidden:NO];
    [self.checkAnswersView.checkButton setHidden:YES];
    [self.checkAnswersView.resultHideButton setHidden:NO];
    [self.topCheck setConstant:-81.0f];
    [self setResultClosed:NO];
    [self layoutIfNeeded];
  }];
}
-(void)resetView{
  NSLog(@"resetView");
  [UIView animateWithDuration:0.5 animations:^{
    [self.checkAnswersView.nextButton setHidden:YES];
    [self.checkAnswersView.againButton setHidden:YES];
    [self.checkAnswersView.checkButton setHidden:NO];
    [self.checkAnswersView.resultHideButton setHidden:YES];
    [self.topCheck setConstant:-40.0f];
    [self setResultClosed:YES];
    [self layoutIfNeeded];
  }];
}
-(void)toggleResult{
  NSLog(@"toggleResult");
  [UIView animateWithDuration:0.5 animations:^{
    if (self.resultClosed) {
      [self.topCheck setConstant:-81.0f];
    }
    else {
      [self.topCheck setConstant:-40.0f];
    }
    [self setResultClosed:!self.resultClosed];
    [self layoutIfNeeded];
  }];
}

#pragma mark Strings

- (NSString *)nextQuestionButtonText {
  return @"Check Answers";
}

#pragma mark Data Display

-(void)updateProgress{
  self.progressView.numberOfQuestions = _numberOfQuestions;
  self.progressView.quizProgress = _quizProgress;
}

-(void)updateProfileImage{
  self.profileImageView.imageURL = self.profileImageURL;
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

- (void)answerButtonPressed:(id)sender{
  UIButton *pressedButton = (UIButton *)sender;
  if (pressedButton.selected == NO){
    for (UIButton *button in self.answerButtons){
      button.selected = NO;
    }
    pressedButton.selected = YES;
  }
}

#pragma mark Factory Methods

- (QIProgressView *)newProgressView{
  QIProgressView *progressView = [[QIProgressView alloc] init];
  [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [progressView setNumberOfQuestions:_numberOfQuestions];
  progressView.quizProgress = _quizProgress;
  return progressView;
}

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}
- (UIImageView *)newDivider{
  UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_divider"]];
  [divider setTranslatesAutoresizingMaskIntoConstraints:NO];
  return divider;
}
- (UIImageView *)newProfileImageBackground{
  UIImageView *profileBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiplechoice_pictureholder"]];
  [profileBackground setContentMode:UIViewContentModeScaleToFill];
  [profileBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
  return profileBackground;
}

- (UIImageView *)newProfileImageTape{
  UIImageView *profileTape = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiplechoice_tape"]];
  [profileTape setContentMode:UIViewContentModeScaleToFill];
  [profileTape setTranslatesAutoresizingMaskIntoConstraints:NO];
  return profileTape;
}

- (AsyncImageView *)newProfileImageView {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  return profileImageView;
}

- (UILabel *)newQuestionLabel {
  UILabel *questionLabel = [[UILabel alloc] init];
  questionLabel.textAlignment = NSTextAlignmentCenter;
  questionLabel.backgroundColor = [UIColor clearColor];
  questionLabel.font = [QIFontProvider fontWithSize:15.0f style:Bold];
  questionLabel.adjustsFontSizeToFitWidth = YES;
  questionLabel.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [questionLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return questionLabel;
}

- (UIButton *)newAnswerButtonWithTitle:(NSString *)title {
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [answerButton setTitle:title forState:UIControlStateNormal];
  answerButton.titleLabel.font = [QIFontProvider fontWithSize:13.0f style:Bold];
  answerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  answerButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
  [answerButton setTitleColor:[UIColor colorWithWhite:0.33f alpha:1.0f] forState:UIControlStateNormal];
  [answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [answerButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 40.0f, 0.0f, 40.0f)];
  [answerButton setBackgroundImage:[[UIImage imageNamed:@"multiplechoice_answer_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 32, 13, 32)] forState:UIControlStateNormal];
  [answerButton setBackgroundImage:[[UIImage imageNamed:@"multiplechoice_answer_btn_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 32, 13, 32)] forState:UIControlStateSelected];
  [answerButton setBackgroundImage:[[UIImage imageNamed:@"multiplechoice_answer_btn_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 32, 13, 32)] forState:UIControlStateSelected | UIControlStateHighlighted];
  [answerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answerButton setAdjustsImageWhenHighlighted:NO];
  [answerButton setReversesTitleShadowWhenHighlighted:NO];
  [answerButton addTarget:self action:@selector(answerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  return answerButton;
}

- (QICheckAnswersView *)newCheckAnswersView{
  QICheckAnswersView *view = [[QICheckAnswersView alloc] init];
  [view.resultHideButton addTarget:self action:@selector(toggleResult) forControlEvents:UIControlEventTouchUpInside];
  [view.againButton addTarget:self action:@selector(againButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [view.checkButton addTarget:self action:@selector(checkButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [view setBackgroundColor:[UIColor clearColor]];
  return view;
}


@end
