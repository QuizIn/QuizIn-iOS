#import "QIBusinessCardQuizView.h"
#import "AsyncImageView.h"

@interface QIBusinessCardQuizView ()

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
@property(nonatomic, strong) NSMutableArray *answersConstraints;

@end


@implementation QIBusinessCardQuizView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
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
  //TODO encapsulate all the card stuff into its own part of the hierarchy
  [self addSubview:self.businessCardBackground];
  [self addSubview:self.profileImageView];
  [self addSubview:self.cardNameLabel];
  [self addSubview:self.cardTitleLabel];
  [self addSubview:self.cardCompanyLabel];
  [self addSubview:self.cardName];
  [self addSubview:self.cardTitle];
  [self addSubview:self.cardCompany];
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
    self.cardConstraints = [NSMutableArray array];
    NSDictionary *cardViews = NSDictionaryOfVariableBindings(_businessCardBackground,
                                                             _profileImageView,
                                                             _cardNameLabel,
                                                             _cardTitleLabel,
                                                             _cardCompanyLabel,
                                                             _cardName,
                                                             _cardTitle,
                                                             _cardCompany);
    NSString *vCard = @"V:|[_businessCardBackground][_profileImageView][_cardNameLabel][_cardTitleLabel][_cardCompanyLabel][_cardName][_cardTitle][_cardCompany]|";
    
    NSArray *vCardConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:vCard
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:cardViews];
    
    [self.cardConstraints addObjectsFromArray:vCardConstraints];
    [self addConstraints:self.cardConstraints];
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

-(UIImageView *)newBusinessCardBackground{
  UIImageView *businessCardBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_paperstack"]];
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





