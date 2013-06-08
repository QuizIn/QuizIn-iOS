#import "QIBusinessCardQuizView.h"
#import "AsyncImageView.h"
#import "QIFontProvider.h"

@interface QIBusinessCardQuizView ()

@property(nonatomic, strong) UIImageView *viewBackground;
@property(nonatomic, strong) UIView *businessCardView;
@property(nonatomic, strong) UIImageView *businessCardBackground;
@property(nonatomic, strong) UIImageView *divider;
@property(nonatomic, strong) AsyncImageView *profileImageView;
@property(nonatomic, strong) UIView *answerSuperView;
@property(nonatomic, strong) UILabel *cardFirstName;
@property(nonatomic, strong) UILabel *cardLastName;
@property(nonatomic, strong) UILabel *cardTitle;
@property(nonatomic, strong) UILabel *cardCompany;
@property(nonatomic, strong) NSMutableArray *answerFullNames;
@property(nonatomic, strong) QIBusinessCardAnswerView *answerName;
@property(nonatomic, strong) QIBusinessCardAnswerView *answerTitle;
@property(nonatomic, strong) QIBusinessCardAnswerView *answerCompany;
@property(nonatomic, strong) NSMutableArray *cardConstraints;
@property(nonatomic, strong) NSMutableArray *answerConstraints;

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
    _answerName = [self newAnswerView];
    _answerTitle = [self newAnswerView];
    _answerCompany = [self newAnswerView];
    _answerFullNames = [self newAnswerFullNames];
    _nextQuestionButton = [self newNextQuestionButton];
    
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

- (void)setAnswerFirstNames:(NSArray *)answerFirstNames {
  if ([answerFirstNames isEqualToArray:_answerFirstNames]) {
    return;
  }
  _answerFirstNames = [answerFirstNames copy];
  [self updateFullNames];
}

- (void)setAnswerLastNames:(NSArray *)answerLastNames {
  if ([answerLastNames isEqualToArray:_answerLastNames]) {
    return;
  }
  _answerLastNames = [answerLastNames copy];
  [self updateFullNames];
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
#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  
  [self addSubview:self.viewBackground];
  [self addSubview:_progressView];
  
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
  [self addSubview:self.nextQuestionButton];
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
    
    //Constrain Background Image
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground);
    
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
    
    [self.cardConstraints addObjectsFromArray:hBackgroundContraints];
    [self.cardConstraints addObjectsFromArray:vBackgroundContraints];

    //Progress View
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
    
    NSString *vBusinessCardView = @"V:|[_progressView][_businessCardView(==180)]";
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
                                                               _nextQuestionButton);
    
    NSString *vAnswerSuperView = @"V:[_businessCardView][_divider(==2)][_answerSuperView][_nextQuestionButton]";
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
    
    NSString *vNextButton = @"V:[_nextQuestionButton(==40)]-3-|";
    NSArray *vNextButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vNextButton
                                            options:0
                                            metrics:nil
                                              views:answerViews];

    NSLayoutConstraint *hNextButton = [NSLayoutConstraint constraintWithItem:_nextQuestionButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    
    NSLayoutConstraint *nextButtonWidth = [NSLayoutConstraint constraintWithItem:_nextQuestionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0f constant:125.0f];
    
    [self.answerConstraints addObjectsFromArray:hDividerConstraints];
    [self.answerConstraints addObjectsFromArray:vAnswerSuperViewConstraints];
    [self.answerConstraints addObjectsFromArray:hAnswerSuperViewConstraints];
    [self.answerConstraints addObjectsFromArray:vAnswerViewConstraints];
    [self.answerConstraints addObjectsFromArray:vNextButtonConstraints];
    [self.answerConstraints addObjectsFromArray:@[hNextButton,nextButtonWidth,centerAnswers]];
  
    [self addConstraints:self.cardConstraints];
    [self addConstraints:self.answerConstraints];
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

-(void)updateFullNames{
  if ([self.answerFirstNames count] == [self.answerLastNames count]){
    for (int i = 0; i<[self.answerLastNames count]; i++){
      self.answerFullNames[i] = [[self.answerFirstNames[i] stringByAppendingString:@" "] stringByAppendingString:self.answerLastNames[i]];
    }
    [self updateAnswerNames];
  }
}

-(void)updateAnswerNames{
  self.answerName.answers = self.answerFullNames;
  
  if (![self.cardFirstName.text isEqualToString:self.answerFirstNames[self.answerName.selectedAnswer]]) {
    self.cardFirstName.text = self.answerFirstNames[self.answerName.selectedAnswer];
    self.cardLastName.text = self.answerLastNames[self.answerName.selectedAnswer];
    self.cardFirstName.alpha = 0;
    self.cardLastName.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    self.cardFirstName.alpha = 1;
    self.cardLastName.alpha = 1;
    [UIView commitAnimations];
  }
}

-(void)updateAnswerCompanies{
  self.answerCompany.answers = self.answerCompanies;
  if (![self.cardCompany.text isEqualToString:self.answerCompanies[self.answerCompany.selectedAnswer]]) {
    self.cardCompany.text = self.answerCompanies[self.answerCompany.selectedAnswer];
    self.cardCompany.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    self.cardCompany.alpha = 1;
    [UIView commitAnimations];
  }
}

-(void)updateAnswerTitles{
  self.answerTitle.answers = self.answerTitles;
  if (![self.cardTitle.text isEqualToString:self.answerTitles[self.answerTitle.selectedAnswer]]){
    self.cardTitle.text = self.answerTitles[self.answerTitle.selectedAnswer];
    self.cardTitle.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    self.cardTitle.alpha = 1;
    [UIView commitAnimations];
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
  UIImageView *businessCardBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardquiz_businesscard"]];
  [businessCardBackground setTranslatesAutoresizingMaskIntoConstraints:NO];
  return businessCardBackground;
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

-(NSMutableArray *)newAnswerFullNames{
  NSMutableArray *fullNames = [NSMutableArray arrayWithCapacity:3];
  return fullNames;
}

-(QIBusinessCardAnswerView *)newAnswerView{
  QIBusinessCardAnswerView *answerView = [[QIBusinessCardAnswerView alloc] init];
  [answerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answerView setDelegate:self];
  return answerView;
}

- (UIButton *)newNextQuestionButton {
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [nextQuestionButton setTitle:[self nextQuestionButtonText] forState:UIControlStateNormal];
  [nextQuestionButton setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] forState:UIControlStateNormal];
  [nextQuestionButton.titleLabel setFont:[QIFontProvider fontWithSize:14.0f style:Regular]];
  [nextQuestionButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [nextQuestionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return nextQuestionButton;
}

@end





