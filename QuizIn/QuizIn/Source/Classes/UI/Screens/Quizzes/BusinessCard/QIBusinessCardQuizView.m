#import "QIBusinessCardQuizView.h"
#import "QIStatsData.h"
#import "QIFontProvider.h"

@interface QIBusinessCardQuizView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) UIView *overlayMask; 
@property (nonatomic, strong) UIView *businessCardView;
@property (nonatomic, strong) UIImageView *businessCardBackground;
@property (nonatomic, strong) UIImageView *divider;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIView *answerSuperView;
@property (nonatomic, strong) UILabel *cardFirstName;
@property (nonatomic, strong) UILabel *cardLastName;
@property (nonatomic, strong) UILabel *cardTitle;
@property (nonatomic, strong) UILabel *cardCompany;
@property (nonatomic, strong) NSMutableArray *answerFirstNames;
@property (nonatomic, strong) NSMutableArray *answerLastNames;
@property (nonatomic, strong) QIBusinessCardAnswerView *answerName;
@property (nonatomic, strong) QIBusinessCardAnswerView *answerTitle;
@property (nonatomic, strong) QIBusinessCardAnswerView *answerCompany;
@property (nonatomic, strong) NSMutableArray *cardConstraints;
@property (nonatomic, strong) NSMutableArray *answerConstraints;
@property (nonatomic, strong) NSLayoutConstraint *topCheck;
@property (nonatomic, strong) NSLayoutConstraint *topRank;
@property (nonatomic, assign) BOOL resultClosed;
@property (nonatomic, assign) BOOL allowAnalytics;
@end


@implementation QIBusinessCardQuizView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    _viewBackground = [self newViewBackground];
    _progressView = [self newProgressView];
    _businessCardView = [self newBusinessCardView];
    _businessCardBackground = [self newBusinessCardBackground];
    _profileImageView = [self newProfileImageView];
    _cardFirstName = [self newCardFirstName];
    _cardLastName = [self newCardLastName];
    _cardTitle = [self newCardTitle];
    _cardCompany = [self newCardCompany];
    _divider = [self newDivider];
    _answerSuperView = [self newAnswerSuperView];
    _answerFirstNames = [NSMutableArray array];
    _answerLastNames = [NSMutableArray array];
    _answerName = [self newAnswerView];
    _answerTitle = [self newAnswerView];
    _answerCompany = [self newAnswerView];
    _checkAnswersView = [self newCheckAnswersView];
    _rankDisplayView = [self newRankDisplayView];
    _overlayMask = [self newOverlayMask]; 
    _resultClosed = YES;
    _allowAnalytics = YES;
    
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

- (void)setQuestionImageURL:(NSURL *)questionImageURL{
  _questionImageURL = questionImageURL;
  [self updateQuestionImage];
}

- (void)setAnswerNames:(NSArray *)answerNames{
  if ([answerNames isEqualToArray:_answerNames]) {
    return;
  }
  _answerNames = answerNames; 
  [self updateAnswerNames];
}

- (void)setAnswerCompanies:(NSArray *)answerCompanies {
  if ([answerCompanies isEqualToArray:_answerCompanies]) {
    return;
  }
  _answerCompanies = [answerCompanies copy];
  [self updateAnswerCompanies];
}
- (void)setAnswerTitles:(NSArray *)answerTitles {
  if ([answerTitles isEqualToArray:_answerTitles]) {
    return;
  }
  _answerTitles = [answerTitles copy];
  [self updateAnswerTitles];
}

- (void)setAnswerPerson:(QIPerson *)answerPerson{
  _answerPerson = answerPerson;
}

- (void)setCorrectNameIndex:(NSUInteger)correctNameIndex{
  _correctNameIndex = correctNameIndex;
}

- (void)setCorrectCompanyIndex:(NSUInteger)correctCompanyIndex{
  _correctCompanyIndex = correctCompanyIndex;
}

- (void)setCorrectTitleIndex:(NSUInteger)correctTitleIndex{
  _correctTitleIndex = correctTitleIndex; 
}

- (void)setLoggedInUserID:(NSString *)loggedInUserID{
  _loggedInUserID = loggedInUserID;
  _rankDisplayView.userID = loggedInUserID; 
}

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  
  [self addSubview:self.viewBackground];
  [self addSubview:self.progressView];
  
  [_businessCardView addSubview:self.businessCardBackground];
  [_businessCardView addSubview:self.profileImageView];
  [_businessCardView addSubview:self.cardFirstName];
  [_businessCardView addSubview:self.cardLastName];
  [_businessCardView addSubview:self.cardTitle];
  [_businessCardView addSubview:self.cardCompany];
  
  [self addSubview:_businessCardView];
  [self addSubview:_divider];
  
  [_answerSuperView addSubview:self.answerName];
  [_answerSuperView addSubview:self.answerTitle];
  [_answerSuperView addSubview:self.answerCompany];
  
  [self addSubview:self.answerSuperView];
  [self addSubview:self.checkAnswersView];
  [self addSubview:self.overlayMask]; 
  [self addSubview:self.rankDisplayView];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.cardConstraints) {
    
    //Self Constraints
    NSDictionary *selfConstraintView =NSDictionaryOfVariableBindings(self);
    
    NSString *hSelfView = @"H:|[self]|";
    NSArray *hSelf =
    [NSLayoutConstraint constraintsWithVisualFormat:hSelfView
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:selfConstraintView];
    
    NSString *vSelfView = @"V:|[self]|";
    NSArray *vSelf =
    [NSLayoutConstraint constraintsWithVisualFormat:vSelfView
                                            options:0
                                            metrics:nil
                                              views:selfConstraintView];
    
    NSMutableArray *selfConstraints = [NSMutableArray array];
    [selfConstraints addObjectsFromArray:hSelf];
    [selfConstraints addObjectsFromArray:vSelf];
    [self.superview addConstraints:selfConstraints];
    
    self.cardConstraints = [NSMutableArray array];
    
    //Constrain Background Image and Overlay Mask
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground,_overlayMask);
    
    NSString *hBackgroundView = @"H:|[_viewBackground]|"; 
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hBackgroundView
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    NSString *vBackgroundView = @"H:|[_viewBackground]|";
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vBackgroundView
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *hOverlayContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_overlayMask]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vOverlayContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_overlayMask]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    [self.cardConstraints addObjectsFromArray:hBackgroundContraints];
    [self.cardConstraints addObjectsFromArray:vBackgroundContraints];
    [self.cardConstraints addObjectsFromArray:hOverlayContraints];
    [self.cardConstraints addObjectsFromArray:vOverlayContraints];

    //Progress View
    NSDictionary *progressView = NSDictionaryOfVariableBindings(_progressView);
    
    NSString *hProgressView = @"H:|[_progressView]|";
    NSArray *hProgressViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hProgressView
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:progressView];
    
    NSString *vProgressView = @"V:|-20-[_progressView(==31)]";
    NSArray *vProgressViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vProgressView
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:progressView];
    
    [self.cardConstraints addObjectsFromArray:vProgressViewConstraints];
    [self.cardConstraints addObjectsFromArray:hProgressViewConstraints];
    
    //Business Card Container View
    NSDictionary *businessCardView = NSDictionaryOfVariableBindings(_businessCardView,_progressView);
    
    NSString *hBusinessCardView = @"H:[_businessCardView(==283)]";
    NSArray *hBusinessCardViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hBusinessCardView
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:businessCardView];
    
    NSString *vBusinessCardView = @"V:[_progressView][_businessCardView(==180)]";
    NSArray *vBusinessCardViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vBusinessCardView
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:businessCardView];

    [self.cardConstraints addObjectsFromArray:vBusinessCardViewConstraints];
    [self.cardConstraints addObjectsFromArray:hBusinessCardViewConstraints];

    //Business Card Background Image
    
    NSLayoutConstraint *hCardBackgroundCenter =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_businessCardView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vCardBackgroundCenter =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_businessCardView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *CardBackgroundWidth =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:283.0f];
    
    NSLayoutConstraint *CardBackgroundHeight =
    [NSLayoutConstraint constraintWithItem:_businessCardBackground attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:180.0f];
    
    [self.cardConstraints addObjectsFromArray:@[hCardBackgroundCenter,vCardBackgroundCenter,CardBackgroundHeight,CardBackgroundWidth]];
    
    //Constrain Business Card Elements
    NSDictionary *cardViews = NSDictionaryOfVariableBindings(_businessCardBackground,
                                                             _profileImageView,
                                                             _cardFirstName,
                                                             _cardLastName,
                                                             _cardTitle,
                                                             _cardCompany);
    NSArray *hProfileImageConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_profileImageView(==93)]"
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSArray *vProfileImageConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-22-[_profileImageView(==93)]"
                                            options:0
                                            metrics:nil
                                              views:cardViews];

    NSString *hFirstName = @"H:[_profileImageView]-5-[_cardFirstName]-|";
    NSArray *hFirstNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hFirstName
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *hLastName = @"H:[_profileImageView]-5-[_cardLastName]-|";
    NSArray *hLastNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hLastName
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *hCompany = @"H:[_profileImageView]-5-[_cardCompany]-|";
    NSArray *hCompanyConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hCompany
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *vCardFirstName = @"V:|-25-[_cardFirstName]";
    NSArray *vCardFirstNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vCardFirstName
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSLayoutConstraint *vCardLastNameConstraint =
    [NSLayoutConstraint constraintWithItem:_cardLastName attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_cardFirstName attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-7.0f];

    NSString *vCardCompany = @"V:[_cardLastName][_cardCompany(==20)]";
    NSArray *vCardCompanyConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vCardCompany
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSString *vCardTitle = @"V:[_profileImageView][_cardTitle]-18-|";
    NSArray *vCardTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vCardTitle
                                            options:NSLayoutFormatAlignAllLeading
                                            metrics:nil
                                              views:cardViews];
    
    NSString *hCardTitle = @"H:[_cardTitle]-|";
    NSArray *hCardTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hCardTitle
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    [self.cardConstraints addObjectsFromArray:hProfileImageConstraints];
    [self.cardConstraints addObjectsFromArray:vProfileImageConstraints];
    [self.cardConstraints addObjectsFromArray:hFirstNameConstraints];
    [self.cardConstraints addObjectsFromArray:hLastNameConstraints];
    [self.cardConstraints addObjectsFromArray:hCompanyConstraints];
    [self.cardConstraints addObjectsFromArray:vCardFirstNameConstraints];
    [self.cardConstraints addObjectsFromArray:@[vCardLastNameConstraint]];
    [self.cardConstraints addObjectsFromArray:vCardCompanyConstraints];
    [self.cardConstraints addObjectsFromArray:vCardTitleConstraints];
    [self.cardConstraints addObjectsFromArray:hCardTitleConstraints];
    
    //Constrain Answers
    self.answerConstraints = [NSMutableArray array];
    NSDictionary *answerViews = NSDictionaryOfVariableBindings(_businessCardView,
                                                               _divider,
                                                               _answerSuperView,
                                                               _answerName,
                                                               _answerTitle,
                                                               _answerCompany,
                                                               _checkAnswersView);
    
    NSString *vAnswerSuperView = @"V:[_businessCardView]-(>=0,<=15)-[_divider(==2)]-(>=0,<=15)-[_answerSuperView]-(>=45,<=75)-|";
    NSArray *vAnswerSuperViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vAnswerSuperView
                                            options:0
                                            metrics:nil
                                              views:answerViews];
    
    NSString *hDivider = @"H:|-[_divider]-|";
    NSArray *hDividerConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hDivider
                                            options:0
                                            metrics:nil
                                              views:answerViews];

    NSString *hAnswerSuperView = @"H:|[_answerSuperView]|";
    NSArray *hAnswerSuperViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hAnswerSuperView
                                            options:0
                                            metrics:nil
                                              views:answerViews];
    
    NSString *vAnswerViews = @"V:|[_answerName(<=100,>=60)][_answerCompany(==_answerName)][_answerTitle(==_answerName)]";
    NSArray *vAnswerViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vAnswerViews
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:answerViews];
    NSArray *groupedAnswerConstraintViews = [NSArray arrayWithObjects:_answerName, _answerCompany, _answerTitle, nil];
    
    NSLayoutConstraint *centerAnswers = [NSLayoutConstraint constraintWithItem:_answerCompany attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_answerSuperView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];

    for (UIView *view in groupedAnswerConstraintViews){
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250.0f]];
    }
    
    [self.answerConstraints addObjectsFromArray:hDividerConstraints];
    [self.answerConstraints addObjectsFromArray:vAnswerSuperViewConstraints];
    [self.answerConstraints addObjectsFromArray:hAnswerSuperViewConstraints];
    [self.answerConstraints addObjectsFromArray:vAnswerViewConstraints];
    [self.answerConstraints addObjectsFromArray:@[centerAnswers]];
    
    //Constrain Check Answers View
    NSLayoutConstraint *centerCheckX = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:81.0f];
    
    _topCheck = [NSLayoutConstraint constraintWithItem:_checkAnswersView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-40.0f];

    [self.answerConstraints addObjectsFromArray:@[centerCheckX,widthCheck,heightCheck,_topCheck]];
    
   //Constrain Rank Display
    NSLayoutConstraint *centerRankX = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220.0f];
  
    _topRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:-220.0f];
    
    [self.cardConstraints addObjectsFromArray:@[centerRankX,widthRank,heightRank,_topRank]];

    [self addConstraints:self.cardConstraints];
    [self addConstraints:self.answerConstraints];
  }
}

#pragma mark Actions

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
    [self.topCheck setConstant:-81.0f];
    [self setResultClosed:NO];
    [self processAnswer];
    [self layoutIfNeeded];
  }];
}
-(void)resetView{
  DDLogInfo(@"resetView");
  [UIView animateWithDuration:0.5 animations:^{
    [self.checkAnswersView resetView]; 
    [self.topCheck setConstant:-40.0f];
    [self setResultClosed:YES];
    [self.answerName.answerScrollView setContentOffset:CGPointZero];
    [self.answerTitle.answerScrollView setContentOffset:CGPointZero];
    [self.answerCompany.answerScrollView setContentOffset:CGPointZero];
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
    [self.overlayMask setHidden:NO];
    [self.rankDisplayView updateLockedStatusLabel]; 
    [self layoutIfNeeded];
  }];
}

-(void)hideRankDisplay{
  [UIView animateWithDuration:0.5 animations:^{
    [self.topRank setConstant:-220.0f];
    [self layoutIfNeeded];
  }
    completion:^(BOOL completion){
      [self.overlayMask setHidden:YES];
  }];
}

-(void)processAnswer{
  QIStatsData *statsEngine = [[QIStatsData alloc] initWithLoggedInUserID:self.loggedInUserID];
  BOOL correct = self.answerName.selectedAnswer == self.correctNameIndex & self.answerCompany.selectedAnswer == self.correctCompanyIndex & self.answerTitle.selectedAnswer == self.correctTitleIndex;
  if (self.interactor) {
    [self.interactor didCheckAnswerIsCorrect:correct sender:self];
  }
  
  if (correct){
    [self.checkAnswersView correct:YES];
    if (self.allowAnalytics){
      [statsEngine updateStatsWithConnectionProfile:self.answerPerson correct:YES];
      if ([statsEngine needsRankUpdate]) {
        self.rankDisplayView.rank = [statsEngine getCurrentRank];
        [self showRankDisplay];
      }
    }
  }
  else{
    [self.checkAnswersView correct:NO];
    if (self.allowAnalytics) {
      [statsEngine updateStatsWithConnectionProfile:self.answerPerson correct:NO];
    }
  }
}

#pragma mark Strings


#pragma mark Data Display
// TODO: (Rene) Replace this with AFNetworking image fetch.
-(void)updateQuestionImage{
//  self.profileImageView.imageURL = self.questionImageURL;
}

-(void)updateProgress{
  self.progressView.numberOfQuestions = _numberOfQuestions;
  self.progressView.quizProgress = _quizProgress;
}

-(void)updateAnswerNames{
  self.answerName.answers = self.answerNames;
  for (int i=0;i<[self.answerNames count];i++){
    NSString *fullName = [self.answerNames objectAtIndex:i];
    NSArray *names = [fullName componentsSeparatedByString:@" "];
    if ([names count] == 0){
      [self.answerFirstNames addObject:@""];
      [self.answerLastNames addObject:@""];
    }
    else if ([names count] == 1) {
      [self.answerFirstNames addObject:[names objectAtIndex:0]];
      [self.answerLastNames addObject:@""];
    }
    else{
      [self.answerFirstNames addObject:[names objectAtIndex:0]];
      NSString *lastNameConcat = @"";
      for (int j = 1; j<[names count];j++){
        lastNameConcat = [lastNameConcat stringByAppendingString:[names objectAtIndex:j]];
      }
      [self.answerLastNames addObject:lastNameConcat]; 
    }
  }
  
  if (![self.cardFirstName.text isEqualToString:self.answerFirstNames[self.answerName.selectedAnswer]]) {
    self.cardFirstName.text = self.answerFirstNames[self.answerName.selectedAnswer];
    self.cardLastName.text = self.answerLastNames[self.answerName.selectedAnswer];
    self.cardFirstName.alpha = 0;
    self.cardLastName.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
      self.cardFirstName.alpha = 1;
      self.cardLastName.alpha = 1;
    }];
  }
}

-(void)updateAnswerCompanies{
  self.answerCompany.answers = self.answerCompanies;
  if (![self.cardCompany.text isEqualToString:self.answerCompanies[self.answerCompany.selectedAnswer]]) {
    self.cardCompany.text = self.answerCompanies[self.answerCompany.selectedAnswer];
    self.cardCompany.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
      self.cardCompany.alpha = 1;
    }];
  }
}

-(void)updateAnswerTitles{
  self.answerTitle.answers = self.answerTitles;
  if (![self.cardTitle.text isEqualToString:self.answerTitles[self.answerTitle.selectedAnswer]]){
    self.cardTitle.text = self.answerTitles[self.answerTitle.selectedAnswer];
    self.cardTitle.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
      self.cardTitle.alpha = 1;
    }];
  }
}

#pragma mark QIBusinessCardAnswerViewDelegate Functions

-(void)answerDidChange:(id)sender{
  QIBusinessCardAnswerView *answerSelection = (QIBusinessCardAnswerView *)sender;
  if ([answerSelection isEqual:self.answerName]){
    [self updateAnswerNames];
  } else if ([answerSelection isEqual:self.answerCompany]){
    [self updateAnswerCompanies];
  } else if ([answerSelection isEqual:self.answerTitle]){
    [self updateAnswerTitles];
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

-(UIView *) newBusinessCardView{
  UIView *businessCardView = [[UIView alloc] init];
  [businessCardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return businessCardView; 
}

-(UIImageView *)newBusinessCardBackground{
  int imagePicker = arc4random_uniform(7);
  DDLogInfo(@"%d",imagePicker);
  NSString *imageName = @"";
  switch (imagePicker) {
    case 0:
      imageName = @"cardquiz_businesscard";
      break;
    case 1:
      imageName = @"cardquiz_businesscard_v1";
      break;
    case 2:
      imageName = @"cardquiz_businesscard_v2";
      break;
    case 3:
      imageName = @"cardquiz_businesscard_v3";
      break;
    case 4:
      imageName = @"cardquiz_businesscard_v4";
      break;
    case 5:
      imageName = @"cardquiz_businesscard_v5";
      break;
    case 6:
      imageName = @"cardquiz_businesscard_v6";
      break;
    default:
      break;
  }
  UIImageView *businessCardBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
  [businessCardBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
  return businessCardBackground;
}

// TODO: (Rene) Replace this with AFNetworking image fetch.
- (UIImageView *)newProfileImageView {
  UIImageView *profileImageView = [[UIImageView alloc] init];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
//  profileImageView.showActivityIndicator = YES;
//  profileImageView.crossfadeDuration = 0.3f;
//  profileImageView.crossfadeImages = YES;
  return profileImageView;
}

-(UILabel *)newCardFirstName{
  UILabel *cardName = [[UILabel alloc] init];
  [cardName setText:self.answerFirstNames[0]];
  [cardName setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardName setBackgroundColor:[UIColor clearColor]];
  [cardName setFont:[QIFontProvider fontWithSize:26.0f style:Regular]];
  [cardName setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  [cardName setAdjustsLetterSpacingToFitWidth:YES];
  [cardName setAdjustsFontSizeToFitWidth:YES];
  [cardName setNumberOfLines:1];
  [cardName setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardName;
}
-(UILabel *)newCardLastName{
  UILabel *cardName = [[UILabel alloc] init];
  [cardName setText:self.answerLastNames[0]];
  [cardName setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardName setBackgroundColor:[UIColor clearColor]];
  [cardName setFont:[QIFontProvider fontWithSize:26.0f style:Regular]];
  [cardName setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  [cardName setAdjustsLetterSpacingToFitWidth:YES];
  [cardName setAdjustsFontSizeToFitWidth:YES];
  [cardName setNumberOfLines:1];
  [cardName setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardName;
}
-(UILabel *)newCardTitle{
  UILabel *cardTitle = [[UILabel alloc] init];
  [cardTitle setText:self.answerTitles[0]];
  [cardTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardTitle setBackgroundColor:[UIColor clearColor]];
  [cardTitle setFont:[QIFontProvider fontWithSize:14.0f style:Italics]];
  [cardTitle setTextColor:[UIColor colorWithWhite:.50f alpha:1.0f]];
  [cardTitle setAdjustsLetterSpacingToFitWidth:YES];
  [cardTitle setAdjustsFontSizeToFitWidth:YES];
  [cardTitle setMinimumScaleFactor:.8f];
  [cardTitle setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardTitle;
}
-(UILabel *)newCardCompany{
  UILabel *cardCompany = [[UILabel alloc] init];
  [cardCompany setText:self.answerCompanies[0]];
  [cardCompany setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardCompany setBackgroundColor:[UIColor clearColor]];
  [cardCompany setFont:[QIFontProvider fontWithSize:14.0f style:Regular]];
  [cardCompany setTextColor:[UIColor colorWithWhite:.50f alpha:1.0f]];
  [cardCompany setAdjustsLetterSpacingToFitWidth:YES];
  [cardCompany setAdjustsFontSizeToFitWidth:YES];
  [cardCompany setMinimumScaleFactor:.8f];
  [cardCompany setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardCompany;
}
- (UIImageView *)newDivider{
  UIImageView *divider = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_divider"]];
  [divider setTranslatesAutoresizingMaskIntoConstraints:NO];
  return divider;
}

-(UIView *)newAnswerSuperView{
  UIView *answerView = [[UIView alloc] init];
  [answerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerView;
}

-(QIBusinessCardAnswerView *)newAnswerView{
  QIBusinessCardAnswerView *answerView = [[QIBusinessCardAnswerView alloc] init];
  [answerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answerView setDelegate:self];
  return answerView;
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

- (QIRankDisplayView *)newRankDisplayView{
  QIRankDisplayView *view = [[QIRankDisplayView alloc] init];
  view.rank = 1;
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [view setBackgroundColor:[UIColor clearColor]];
  return view;
}

- (UIView *)newOverlayMask{
  UIView *view = [[UIView alloc] init];
  [view setHidden:YES];
  [view setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:.8f]];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  return view;
}

@end





