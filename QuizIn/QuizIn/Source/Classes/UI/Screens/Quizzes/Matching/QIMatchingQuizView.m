#import "QIMatchingQuizView.h"
#import "AsyncImageView.h"
#import "QIFontProvider.h"
#import "QIStatsData.h"

@interface QIMatchingQuizView ()

@property(nonatomic, strong) UIImageView *viewBackground;
@property(nonatomic, strong) UIImageView *divider;
@property(nonatomic, strong) UIView *questionView;
@property(nonatomic, strong) NSArray *questionButtons;
@property(nonatomic, strong) NSArray *questionButtonImages;
@property(nonatomic, strong) NSMutableArray *questionColorImagesQueue;
@property(nonatomic, strong) NSMutableArray *questionColorImages;
@property(nonatomic, strong) NSArray *questionButtonTapes;
@property(nonatomic, strong) UIView *answerView;
@property(nonatomic, strong) NSArray *answerButtons;
@property(nonatomic, strong) NSMutableArray *answerColorImagesQueue;
@property(nonatomic, strong) NSMutableArray *answerColorImages;
@property(nonatomic, strong, readwrite) UIButton *nextQuestionButton;
@property(nonatomic) BOOL overwriteSelection;
@property(nonatomic, strong) NSMutableArray *progressViewConstraints;
@property(nonatomic, strong) NSMutableArray *questionConstraints;
@property(nonatomic, strong) NSMutableArray *answerConstraints;
@property(nonatomic, strong) NSLayoutConstraint *topCheck;
@property (nonatomic, strong) NSLayoutConstraint *topRank;
@property(nonatomic, assign) BOOL resultClosed;
@property (nonatomic, assign) BOOL allowAnalytics;
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
    _rankDisplayView = [self newRankDisplayView];
    _answerView = [self newAnswerView];
    _answerButtons = @[];
    _questionButtons = @[];
    _questionButtonImages = @[];
    _questionButtonTapes = @[];
    _questionColorImagesQueue = [self newQueue];
    _answerColorImagesQueue = [self newQueue];
    _questionColorImages = [self newQuestionColorImages];
    _answerColorImages = [self newAnswerColorImages];
    _overwriteSelection = NO; 
    _checkAnswersView = [self newCheckAnswersView];
    _resultClosed = YES;
    _allowAnalytics = YES;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];    
    [self constructViewHierarchy];
  }
  return self;
}


#pragma mark Properties

- (void)setQuestionImageURLs:(NSArray *)questionImageURLs{
  if ([questionImageURLs isEqualToArray:_questionImageURLs]) {
    return;
  }
  _questionImageURLs = [questionImageURLs copy];;
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

- (void)setLoggedInUserID:(NSString *)loggedInUserID{
  _loggedInUserID = loggedInUserID;
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
  [self addSubview:_checkAnswersView];
  [self addSubview:_rankDisplayView];
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
    
   //[self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:_progressView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_questionView attribute:NSLayoutAttributeTop multiplier:1.0f constant:10.0f]];
    
    NSString *vQuestionAnswerView = @"V:[_progressView]-(>=-10,<=10)-[_questionView(<=200)]-(>=2,<=10)-[_divider(==2)]-(>=0,<=4)-[_answerView(>=180)]-(>=45,<=75)-|";
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
      [self.questionConstraints addObject:[NSLayoutConstraint constraintWithItem:_questionButtonTapes[i] attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:47.0f]];
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
                                         nil];

    for (UIButton *button in self.answerButtons){
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250.0f]];
    }
    
    NSString *vAnswerButtonsView = @"V:|[_answerButtons0(==_answerButtons0)][_answerButtons1(==_answerButtons0)][_answerButtons2(==_answerButtons0)][_answerButtons3(==_answerButtons0)]|";
    
    NSArray *vAnswerButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vAnswerButtonsView
                                            options:0
                                            metrics:nil
                                              views:answerButtonViews];
    
    [self.answerConstraints addObjectsFromArray:vAnswerButtonConstraints];

    //Constrain Check Answers View
    NSLayoutConstraint *centerCheckX = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:81.0f];
    
    _topCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-40.0f];
    
    [self.answerConstraints addObjectsFromArray:@[centerCheckX,widthCheck,heightCheck,_topCheck]];
    
    //Constrain Rank Display
    NSLayoutConstraint *centerRankX = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:81.0f];
    
    _topRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:-81.0f];
    
    [self.answerConstraints addObjectsFromArray:@[centerRankX,widthRank,heightRank,_topRank]];
    
    [self addConstraints:self.progressViewConstraints];
    [self addConstraints:self.answerConstraints];
    [self addConstraints:self.questionConstraints];
  }
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
  if ([self.questionImageURLs count] == 0) {
    return;
  }
  NSMutableArray *questionButtons = [NSMutableArray arrayWithCapacity:[self.questionImageURLs count]];
  NSMutableArray *questionButtonImages = [NSMutableArray arrayWithCapacity:[self.questionImageURLs count]];
  NSMutableArray *questionButtonTapes = [NSMutableArray arrayWithCapacity:[self.questionImageURLs count]];
  
  for (NSURL *questionImageURL in self.questionImageURLs) {
    UIButton *questionButton = [self newQuestionButton];
    [questionButtons addObject:questionButton];
    AsyncImageView *questionImage = [self newQuestionButtonImageWithURL:questionImageURL];
    [questionButtonImages addObject:questionImage];
    UIImageView *tape = [self newQuestionButtonTape];
    [questionButtonTapes addObject:tape];
  }
  
  _questionButtonImages = [questionButtonImages copy];
  _questionButtonTapes = [questionButtonTapes copy];
  self.questionButtons = [questionButtons copy];
  return;
}

#pragma mark actions
- (void)checkForComplete{
  int total = [self.questionButtons count] + [self.answerButtons count];
  int countComplete = 0;
  for (UIButton *button in self.questionButtons) {
    if (button.selected) {
      countComplete++; 
    }
  }
  for (UIButton *button in self.answerButtons) {
    if (button.selected) {
      countComplete++;
    }
  }
  if (total == countComplete){
    [self.checkAnswersView.checkButton setEnabled:YES]; 
  }
  else{
    [self.checkAnswersView.checkButton setEnabled:NO];
  }
}

-(NSNumber *)dequeueQuestionColorImage{
  NSNumber *lastImageIndex = [self.questionColorImagesQueue lastObject];
  [self.questionColorImagesQueue removeLastObject];
  return lastImageIndex;
}

-(NSNumber *)dequeueAnswerColorImage{
  NSNumber *lastImageIndex = [self.answerColorImagesQueue lastObject];
  [self.answerColorImagesQueue removeLastObject];
  return lastImageIndex;
}

- (void)questionButtonPressed:(id)sender{
  UIButton *pressedButton = (UIButton *)sender;
  int questionColorImageIndex  = 0;
  if (!pressedButton.selected) {
    questionColorImageIndex = [[self dequeueQuestionColorImage] integerValue];
    [pressedButton setBackgroundImage:self.questionColorImages[questionColorImageIndex] forState:UIControlStateSelected];
    pressedButton.tag = questionColorImageIndex;
    self.overwriteSelection = !self.overwriteSelection;
  }
  else {
    if (self.overwriteSelection){
      questionColorImageIndex = [[self dequeueQuestionColorImage] integerValue];
      [pressedButton setBackgroundImage:self.questionColorImages[questionColorImageIndex] forState:UIControlStateSelected];
      self.overwriteSelection = NO;
      pressedButton.tag = questionColorImageIndex; 
    }
    else {
      questionColorImageIndex = [self.questionColorImages indexOfObjectIdenticalTo:[pressedButton backgroundImageForState:UIControlStateSelected]];
      [self.answerColorImagesQueue addObject:[NSNumber numberWithInt:questionColorImageIndex]];
      self.overwriteSelection = YES;
    }
  }
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:.4];
  pressedButton.selected = YES;
  for (UIButton *button in self.questionButtons) {
    if (pressedButton != button & button.tag == questionColorImageIndex){
      button.selected = NO;
    }
    [button setUserInteractionEnabled:NO];
    [button setAlpha:0.4f];
  }
  for (UIButton *button in self.answerButtons) {
    [button setUserInteractionEnabled:YES];
    [button setAlpha:1.0f];
  }
  [UIView commitAnimations];
}

- (void)answerButtonPressed:(id)sender{
  UIButton *pressedButton = (UIButton *)sender;
  int answerColorImageIndex = 0;
  if (!pressedButton.selected) {
    answerColorImageIndex = [[self dequeueAnswerColorImage] integerValue];
    [pressedButton setBackgroundImage:self.answerColorImages[answerColorImageIndex] forState:UIControlStateSelected];
    pressedButton.tag = answerColorImageIndex;
    self.overwriteSelection = !self.overwriteSelection;
  }
  else {
    if (self.overwriteSelection){
      answerColorImageIndex = [[self dequeueAnswerColorImage] integerValue];
      [pressedButton setBackgroundImage:self.answerColorImages[answerColorImageIndex] forState:UIControlStateSelected];
      pressedButton.tag = answerColorImageIndex;
      self.overwriteSelection = NO;
    }
    else {
      answerColorImageIndex = [self.answerColorImages indexOfObjectIdenticalTo:[pressedButton backgroundImageForState:UIControlStateSelected]];
      [self.questionColorImagesQueue addObject:[NSNumber numberWithInt:answerColorImageIndex]];
      self.overwriteSelection = YES;
    }
  }

  pressedButton.selected = YES;
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:.4];
  for (UIButton *button in self.answerButtons) {
    if (pressedButton != button & button.tag == answerColorImageIndex){
      button.selected = NO;
    }
    [button setUserInteractionEnabled:NO];
    [button setAlpha:0.4f];
  }
  for (UIButton *button in self.questionButtons) {
    [button setUserInteractionEnabled:YES];
    [button setAlpha:1.0f];
  }
  [UIView commitAnimations];
}

-(void)checkButtonPressed{
  DDLogInfo(@"checkButton Pressed");
  [self showResult];
}
-(void)againButtonPressed{
  DDLogInfo(@"againButton Pressed");
  [self setAllowAnalytics:NO];
  [self resetView];
}
-(void)showResult{
  DDLogInfo(@"showResult");
  [UIView animateWithDuration:0.5 animations:^{
    [self.checkAnswersView.nextButton setHidden:NO];
    [self.checkAnswersView.againButton setHidden:NO];
    [self.checkAnswersView.checkButton setHidden:YES];
    [self.checkAnswersView.resultHideButton setHidden:NO];
    [self.topCheck setConstant:-81.0f];
    [self setResultClosed:NO];
    [self processAnswer];
    [self layoutIfNeeded];
  }];
}
-(void)resetView{
  DDLogInfo(@"resetView");
  [UIView animateWithDuration:0.5 animations:^{
    [self.checkAnswersView.nextButton setHidden:YES];
    [self.checkAnswersView.againButton setHidden:YES];
    [self.checkAnswersView.checkButton setHidden:NO];
    [self.checkAnswersView.checkButton setEnabled:NO];
    [self.checkAnswersView.resultHideButton setHidden:YES];
    [self.topCheck setConstant:-40.0f];
    [self setResultClosed:YES];
    for (UIButton *button in self.questionButtons){
      [button setSelected:NO];
      [button setUserInteractionEnabled:YES];
      [button setAlpha:1.0f];
    }
    for (UIButton *button in self.answerButtons){
      [button setSelected:NO];
      [button setUserInteractionEnabled:YES];
      [button setAlpha:1.0f];
    }
    self.questionColorImagesQueue = [self newQueue];
    self.answerColorImagesQueue = [self newQueue];
    [self layoutIfNeeded];
  }];
}
-(void)toggleResult{
  DDLogInfo(@"toggleResult");
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

-(void)showRankDisplay{
  [UIView animateWithDuration:0.5 animations:^{
    [self.topRank setConstant:100.0f];
    [NSTimer scheduledTimerWithTimeInterval:7.0f target:self selector:@selector(hideRankDisplay) userInfo:nil repeats:NO];
    [self layoutIfNeeded];
  }];
}

-(void)hideRankDisplay{
  [UIView animateWithDuration:0.5 animations:^{
    [self.topRank setConstant:-81.0f];
    [self layoutIfNeeded];
  }];
}

-(void)processAnswer{
  QIStatsData *statsEngine = [[QIStatsData alloc] initWithLoggedInUserID:self.loggedInUserID];
  BOOL correct = NO; //test For Correct Answer
  if (correct){
    [self.checkAnswersView correct:YES];
    if (self.allowAnalytics){
      //[statsEngine updateStatsWithConnectionProfile:self.answerPerson correct:YES];
      if ([statsEngine needsRankUpdate]) {
        self.rankDisplayView.rank = [statsEngine getCurrentRank];
        [self showRankDisplay];
      }
    }
  }
  else{
    [self.checkAnswersView correct:NO];
    if (self.allowAnalytics) {
      //[statsEngine updateStatsWithConnectionProfile:self.answerPerson correct:NO];
    }
  }
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
  [questionButton setBackgroundImage:[[UIImage imageNamed:@"match_pictureholder"] resizableImageWithCapInsets:UIEdgeInsetsMake(16,16,16,16)] forState:UIControlStateNormal];
  [questionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [questionButton setTag:99];
  [questionButton addTarget:self action:@selector(questionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [questionButton addTarget:self action:@selector(checkForComplete) forControlEvents:UIControlEventTouchUpInside];
  return questionButton;
}

- (AsyncImageView *)newQuestionButtonImageWithURL:(NSURL *)imageURL{
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  profileImageView.imageURL = imageURL;
  return profileImageView;
}

- (UIImageView *)newQuestionButtonTape{
  UIImageView *profileTape = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"multiplechoice_tape"]];
  [profileTape setContentMode:UIViewContentModeScaleToFill];
  [profileTape setTranslatesAutoresizingMaskIntoConstraints:NO];
  return profileTape;
}
-(NSMutableArray *)newQueue{
  return [NSMutableArray arrayWithObjects:
          [NSNumber numberWithInt:0],
          [NSNumber numberWithInt:1],
          [NSNumber numberWithInt:2],
          [NSNumber numberWithInt:3],
          nil];
}

-(NSMutableArray *)newQuestionColorImages{
  UIEdgeInsets insets = UIEdgeInsetsMake(16.0f, 16.0f, 16.0f, 16.0f);
  return [NSMutableArray arrayWithObjects:
          [[UIImage imageNamed:@"match_pictureholder_bluev1"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_pictureholder_bluev2"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_pictureholder_bluev3"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_pictureholder_bluev4"] resizableImageWithCapInsets:insets],
          nil];
}

-(NSMutableArray *)newAnswerColorImages{
  UIEdgeInsets insets = UIEdgeInsetsMake(15.0f, 18.0f, 15.0f, 18.0f);
  return [NSMutableArray arrayWithObjects:
          [[UIImage imageNamed:@"match_answerbox_bluev1"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_answerbox_bluev2"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_answerbox_bluev3"] resizableImageWithCapInsets:insets],
          [[UIImage imageNamed:@"match_answerbox_bluev4"] resizableImageWithCapInsets:insets],
          nil];
}

- (UIButton *)newAnswerButtonWithTitle:(NSString *)title {
  UIButton *answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [answerButton setTitle:title forState:UIControlStateNormal];
  answerButton.titleLabel.font = [QIFontProvider fontWithSize:13.0f style:Bold];
  answerButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  answerButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
  [answerButton setBackgroundImage:[[UIImage imageNamed:@"match_answerbox_std"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0f, 18.0f, 15.0f, 18.0f)]  forState:UIControlStateNormal];
  [answerButton setTitleColor:[UIColor colorWithWhite:0.33f alpha:1.0f] forState:UIControlStateNormal];
  [answerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [answerButton setTitleEdgeInsets:UIEdgeInsetsMake(15.0f, 18.0f, 15.0f, 18.0f)];
  [answerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answerButton setAdjustsImageWhenHighlighted:NO];
  [answerButton setReversesTitleShadowWhenHighlighted:NO];
  [answerButton setTag:99];
  [answerButton addTarget:self action:@selector(answerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  [answerButton addTarget:self action:@selector(checkForComplete) forControlEvents:UIControlEventTouchUpInside];
  return answerButton;
}

- (QICheckAnswersView *)newCheckAnswersView{
  QICheckAnswersView *view = [[QICheckAnswersView alloc] init];
  [view.resultHideButton addTarget:self action:@selector(toggleResult) forControlEvents:UIControlEventTouchUpInside];
  [view.againButton addTarget:self action:@selector(againButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [view.checkButton addTarget:self action:@selector(checkButtonPressed) forControlEvents:UIControlEventTouchUpInside];
  [view.checkButton setEnabled:NO];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [view setBackgroundColor:[UIColor clearColor]];
  return view;
}

- (QIRankDisplayView *)newRankDisplayView{
  QIRankDisplayView *view = [[QIRankDisplayView alloc] init];
  view.rank = 1;
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [view setBackgroundColor:[UIColor clearColor]];
  return view;
}

@end






