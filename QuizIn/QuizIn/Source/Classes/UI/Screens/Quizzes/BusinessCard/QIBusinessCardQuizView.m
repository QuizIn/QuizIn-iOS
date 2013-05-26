#import "QIBusinessCardQuizView.h"
#import "AsyncImageView.h"

@interface QIBusinessCardQuizView ()

@property(nonatomic, strong) UIView *businessCardView;
@property(nonatomic, strong) UIImageView *businessCardBackground;
@property(nonatomic, strong) AsyncImageView *profileImageView;
@property(nonatomic, strong) UILabel *cardNameLabel;
@property(nonatomic, strong) UILabel *cardTitleLabel;
@property(nonatomic, strong) UILabel *cardCompanyLabel;
@property(nonatomic, strong) UILabel *cardName;
@property(nonatomic, strong) UILabel *cardTitle;
@property(nonatomic, strong) UILabel *cardCompany;
@property(nonatomic, strong) UIView *answerName;
@property(nonatomic, strong) UIView *answerTitle;
@property(nonatomic, strong) UIView *answerCompany;
@property(nonatomic, strong) UIButton *nextQuestionButton;
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
    
    _progressView = [self newProgressView];
    _businessCardView = [self newBusinessCardView];
    _businessCardBackground = [self newBusinessCardBackground];
    _profileImageView = [self newProfileImageView];
    _cardNameLabel = [self newCardNameLabel];
    _cardTitleLabel = [self newCardTitleLabel];
    _cardCompanyLabel = [self newCardCompanyLabel];
    _cardName = [self newCardName];
    _cardTitle = [self newCardTitle];
    _cardCompany = [self newCardCompany];
    _answerName = [self newAnswerName];
    _answerTitle = [self newAnswerTitle];
    _answerCompany = [self newAnswerCompany];
    _nextQuestionButton = [self newNextQuestionButton];
    
    //TODO rkuhlman not sure if this shoudl stay here.
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self constructViewHierarchy];
  }
  return self;
}


#pragma mark Properties
/*
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
*/

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
  
  [_businessCardView addSubview:self.businessCardBackground];
  [_businessCardView addSubview:self.profileImageView];
  [_businessCardView addSubview:self.cardNameLabel];
  [_businessCardView addSubview:self.cardTitleLabel];
  [_businessCardView addSubview:self.cardCompanyLabel];
  [_businessCardView addSubview:self.cardName];
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
    
    //Progress View
    self.cardConstraints = [NSMutableArray array];
    
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
    
    NSString *hBusinessCardView = @"H:|[_businessCardView]|";
    NSArray *hBusinessCardViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:hBusinessCardView
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:businessCardView];
    
    NSString *vBusinessCardView = @"V:|[_progressView][_businessCardView(==220)]";
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
                                                             _cardNameLabel,
                                                             _cardTitleLabel,
                                                             _cardCompanyLabel,
                                                             _cardName,
                                                             _cardTitle,
                                                             _cardCompany);
    NSArray *hProfileImageConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-38-[_profileImageView(==93)]"
                                            options:0
                                            metrics:nil
                                              views:cardViews];
    
    NSArray *vProfileImageConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_profileImageView(==93)]"
                                            options:0
                                            metrics:nil
                                              views:cardViews];

    NSString *vCard = @"V:|-[_cardNameLabel][_cardTitleLabel][_cardCompanyLabel][_cardName][_cardTitle][_cardCompany]-|";
    
    NSArray *vCardConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vCard
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:cardViews];
    NSLayoutConstraint *hCardCenter =
    [NSLayoutConstraint constraintWithItem:_cardNameLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_businessCardBackground attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    [self.cardConstraints addObjectsFromArray:@[hCardCenter]];
    [self.cardConstraints addObjectsFromArray:hProfileImageConstraints];
    [self.cardConstraints addObjectsFromArray:vProfileImageConstraints];
    [self.cardConstraints addObjectsFromArray:vCardConstraints];
    
    self.answerConstraints = [NSMutableArray array];
    NSDictionary *answerViews = NSDictionaryOfVariableBindings(_businessCardView,
                                                               _answerName,
                                                               _answerTitle,
                                                               _answerCompany,
                                                               _nextQuestionButton);

    NSString *vAnswerViews = @"V:[_businessCardView]-[_answerName]-[_answerTitle(==_answerName)]-[_answerCompany(==_answerName)]-[_nextQuestionButton(==_answerName)]|";
    
    NSArray *vAnswerViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vAnswerViews
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:answerViews];
    NSArray *groupedAnswerConstraintViews = [NSArray arrayWithObjects:_answerName, _answerCompany, _answerTitle, nil];
    
    NSMutableArray *choiceButtonConstraints = [NSMutableArray array];
    for (UIView *view in groupedAnswerConstraintViews){
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
      [self.answerConstraints addObject:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:250.0f]];
    }
    
    [self.answerConstraints addObjectsFromArray:vAnswerViewContraints];
    
    [self addConstraints:self.cardConstraints];
    [self addConstraints:self.answerConstraints];
  }
}

#pragma mark Strings
- (NSString *)cardNameLabelText {
  return @"Name:";
}
- (NSString *)cardTitleLabelText {
  return @"Title:";
}
- (NSString *)cardCompanyLabelText {
  return @"Company:";
}
- (NSString *)nextQuestionButtonText {
  return @"Next Question >";
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
  [progressView setBackgroundColor:[UIColor lightGrayColor]];
  return progressView;
}

-(UIView *) newBusinessCardView{
  UIView *businessCardView = [[UIView alloc] init];
  [businessCardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [businessCardView setBackgroundColor:[UIColor grayColor]];
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


-(UILabel *)newCardNameLabel{
  UILabel *cardNameLabel = [[UILabel alloc] init];
  cardNameLabel.text = [self cardNameLabelText];
  [cardNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardNameLabel;
}
-(UILabel *)newCardTitleLabel{
  UILabel *cardTitleLabel = [[UILabel alloc] init];
  cardTitleLabel.text = [self cardTitleLabelText];
  [cardTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardTitleLabel;
}
-(UILabel *)newCardCompanyLabel{
  UILabel *cardCompanyLabel = [[UILabel alloc] init];
  cardCompanyLabel.text = [self cardCompanyLabelText];
  [cardCompanyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardCompanyLabel;
}
-(UILabel *)newCardName{
  UILabel *cardName = [[UILabel alloc] init];
  cardName.text = @"Rick Kuhlman";
  [cardName setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardName;
}
-(UILabel *)newCardTitle{
  UILabel *cardTitle = [[UILabel alloc] init];
  cardTitle.text = @"Senior Product Manager";
  [cardTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardTitle;
}
-(UILabel *)newCardCompany{
  UILabel *cardCompany = [[UILabel alloc] init];
  cardCompany.text = @"Invodo Inc."; 
  [cardCompany setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardCompany;
}
-(UIView *)newAnswerName{
  UIView *answerName = [[UIView alloc] init];
  [answerName setBackgroundColor:[UIColor grayColor]];
  [answerName setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerName; 
}
-(UIView *)newAnswerTitle{
  UIView *answerTitle = [[UIView alloc] init];
  [answerTitle setBackgroundColor:[UIColor grayColor]];
  [answerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerTitle;
}
-(UIView *)newAnswerCompany{
  UIView *answerCompany= [[UIView alloc] init];
  [answerCompany setBackgroundColor:[UIColor grayColor]];
  [answerCompany setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerCompany;
}
-(UIButton *)newNextQuestionButton;{
  UIButton *nextQuestionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [nextQuestionButton setTitle:[self nextQuestionButtonText] forState:UIControlStateNormal];
  [nextQuestionButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return nextQuestionButton;
}

@end





