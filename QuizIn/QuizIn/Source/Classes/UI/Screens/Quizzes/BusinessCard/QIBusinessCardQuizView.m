#import "QIBusinessCardQuizView.h"
#import "AsyncImageView.h"
#import "BusinessCardAnswer/QIBusinessCardAnswerView.h"
#import "QIFontProvider.h"

@interface QIBusinessCardQuizView ()

@property(nonatomic, strong) UIImageView *viewBackground;
@property(nonatomic, strong) UIView *businessCardView;
@property(nonatomic, strong) UIImageView *businessCardBackground;
@property(nonatomic, strong) AsyncImageView *profileImageView;
@property(nonatomic, strong) UILabel *cardFirstName;
@property(nonatomic, strong) UILabel *cardLastName;
@property(nonatomic, strong) UILabel *cardTitle;
@property(nonatomic, strong) UILabel *cardCompany;
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
    _answerName = [self newAnswerView];
    _answerTitle = [self newAnswerView];
    _answerCompany = [self newAnswerView];
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
  [self addSubview:self.answerName];
  [self addSubview:self.answerTitle];
  [self addSubview:self.answerCompany];
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
    
    //Business Card Elements
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
    
    self.answerConstraints = [NSMutableArray array];
    NSDictionary *answerViews = NSDictionaryOfVariableBindings(_businessCardView,
                                                               _answerName,
                                                               _answerTitle,
                                                               _answerCompany,
                                                               _nextQuestionButton);

    NSString *vAnswerViews = @"V:[_businessCardView][_answerName]-[_answerTitle(==_answerName)]-[_answerCompany(==_answerName)]";
    NSArray *vAnswerViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vAnswerViews
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:answerViews];
    NSArray *groupedAnswerConstraintViews = [NSArray arrayWithObjects:_answerName, _answerCompany, _answerTitle, nil];
    
    for (UIView *view in groupedAnswerConstraintViews){
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250.0f]];
    }
    
    NSString *vNextButton = @"V:[_answerCompany][_nextQuestionButton(>=40)]-3-|";
    NSArray *vNextButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vNextButton
                                            options:0
                                            metrics:nil
                                              views:answerViews];

    NSLayoutConstraint *hNextButton = [NSLayoutConstraint constraintWithItem:_nextQuestionButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0f constant:-10.0f];
    
    [self.answerConstraints addObjectsFromArray:vAnswerViewConstraints];
    [self.answerConstraints addObjectsFromArray:vNextButtonConstraints];
    [self.answerConstraints addObjectsFromArray:@[hNextButton]];
  
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
  [cardName setText:@"Rick"];
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
  [cardName setText:@"Kuhlman"];
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
  cardTitle.text = @"Senior Product Manager";
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
  cardCompany.text = @"Invodo Inc.";
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
-(QIBusinessCardAnswerView *)newAnswerView{
  QIBusinessCardAnswerView *answerView = [[QIBusinessCardAnswerView alloc] init];
  //[answerName setBackgroundColor:[UIColor grayColor]];
  [answerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerView;
}

- (UIButton *)newNextQuestionButton {
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [nextQuestionButton setTitle:[self nextQuestionButtonText] forState:UIControlStateNormal];
  [nextQuestionButton setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] forState:UIControlStateNormal];
  [nextQuestionButton.titleLabel setFont:[QIFontProvider fontWithSize:16.0f style:Regular]];
  [nextQuestionButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
  [nextQuestionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return nextQuestionButton;
}
@end





