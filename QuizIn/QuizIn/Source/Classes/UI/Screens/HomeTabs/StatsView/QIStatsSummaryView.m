
#import "QIStatsSummaryView.h"
#import "QIFontProvider.h"

@interface QIStatsSummaryView ()
@property (nonatomic, strong) UIImageView *correctAnswersBackground;
@property (nonatomic, strong) UILabel *correctAnswersLabel;
@property (nonatomic, strong) UIImageView *incorrectAnswersBackground;
@property (nonatomic, strong) UILabel *incorrectAnswersLabel;
@property (nonatomic, strong) UIImageView *currentRankBackground;
@property (nonatomic, strong) UILabel *currentRankLabel;
@property (nonatomic, strong) UILabel *leastLabel;
@property (nonatomic, strong) UIImageView *quizCard; 
@property (nonatomic, strong) NSMutableArray *viewConstraints;

@end

@implementation QIStatsSummaryView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _pieChartView = [self newPieChartView]; 
      _sorterSegmentedControl = [self newSorter];
      _leastQuizButton = [self newQuizBeginButton];
      _leastQuizLockButton = [self newQuizLockButton]; 
      _correctAnswersBackground = [self newLabelBackground];
      _correctAnswersLabel = [self newSummaryLabel];
      _incorrectAnswersBackground = [self newLabelBackground];
      _incorrectAnswersLabel = [self newSummaryLabel];
      _currentRankBackground = [self newLabelBackground];
      _currentRankLabel = [self newSummaryLabel];
      _leastLabel = [self newLeastLabelWithText:@"RefreshQuiz"];
      _quizCard = [self newTopLeftCard]; 
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark Properties

- (void)setCorrectAnswers:(NSNumber *)correctAnswers{
  _correctAnswers = correctAnswers;
  [self updateCorrectAnswers]; 
}

- (void)setIncorrectAnswers:(NSNumber *)incorrectAnswers {
  _incorrectAnswers = incorrectAnswers;
  [self updateIncorrectAnswers]; 
}

- (void)setCurrentRank:(NSNumber *)currentRank{
  _currentRank = currentRank;
  [self updateCurrentRank]; 
}

#pragma mark Data Layout
- (void)updateCorrectAnswers{
  NSMutableAttributedString *labelAttributes = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"CorrectAnswers: %d",[self.correctAnswers integerValue]]];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Bold] range:NSMakeRange(0,7)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.33f alpha:1.0f] range:NSMakeRange(0,7)];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Regular] range:NSMakeRange(7,labelAttributes.string.length-7)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.33f alpha:1.0f] range:NSMakeRange(7,8)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f/255.0f green:178.0f/255.0f blue:61.0f/255.0f alpha:1.0] range:NSMakeRange(15,(labelAttributes.string.length-15))];
  [self.correctAnswersLabel setAttributedText:labelAttributes];
}

- (void)updateIncorrectAnswers{
  NSMutableAttributedString *labelAttributes = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"IncorrectAnswers: %d",[self.incorrectAnswers integerValue]]];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Bold] range:NSMakeRange(0,9)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.33f alpha:1.0f] range:NSMakeRange(0,9)];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Regular] range:NSMakeRange(9,labelAttributes.string.length-9)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.33f alpha:1.0f] range:NSMakeRange(9,8)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f/255.0f green:178.0f/255.0f blue:61.0f/255.0f alpha:1.0] range:NSMakeRange(17,(labelAttributes.string.length-17))];
  [self.incorrectAnswersLabel setAttributedText:labelAttributes];
}

- (void)updateCurrentRank{
  NSMutableAttributedString *labelAttributes = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"CurrentRank: %d",[self.currentRank integerValue]]];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Bold] range:NSMakeRange(0,7)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.33f alpha:1.0f] range:NSMakeRange(0,7)];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Regular] range:NSMakeRange(7,labelAttributes.string.length-7)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:.33f alpha:1.0f] range:NSMakeRange(7,5)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0f/255.0f green:178.0f/255.0f blue:61.0f/255.0f alpha:1.0] range:NSMakeRange(12,(labelAttributes.string.length-12))];
  [self.currentRankLabel setAttributedText:labelAttributes];
}


#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.sorterSegmentedControl];
  [self addSubview:self.pieChartView];
  [self addSubview:self.correctAnswersBackground]; 
  [self addSubview:self.correctAnswersLabel];
  [self addSubview:self.incorrectAnswersBackground]; 
  [self addSubview:self.incorrectAnswersLabel];
  [self addSubview:self.currentRankBackground]; 
  [self addSubview:self.currentRankLabel];
  [self addSubview:self.quizCard]; 
  [self addSubview:self.leastQuizButton];
  [self addSubview:self.leastQuizLockButton]; 
  [self addSubview:self.leastLabel];
  [self drawPieChart]; 
}

- (void)drawPieChart{
  [self.pieChartView customamizeDraw:self.pieChartView pieCentre:CGPointMake(60, 60) animationSpeed:2.0f labelRadius:60.0f];
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(_sorterSegmentedControl,_pieChartView,_correctAnswersBackground, _correctAnswersLabel, _incorrectAnswersBackground, _incorrectAnswersLabel, _currentRankBackground, _leastQuizButton, _leastQuizLockButton, _currentRankLabel, _leastLabel, _quizCard);
  
  NSArray *hViewConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-5-[_sorterSegmentedControl(==310)]"
                                          options:0
                                          metrics:nil
                                            views:views];

  NSArray *vViewConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:[_sorterSegmentedControl(==30)]-5-|"
                                          options:0
                                          metrics:nil
                                            views:views];
  
  NSArray *hPieConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:[_pieChartView(==120)]-10-|"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *vPieConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-10-[_pieChartView(==120)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *hCorrectBackgroundConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-10-[_correctAnswersBackground(==170)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *hIncorrectBackgroundConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-10-[_incorrectAnswersBackground(_correctAnswersBackground)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *hRankBackgroundConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-10-[_currentRankBackground(_correctAnswersBackground)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  
  NSArray *hCorrectConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-15-[_correctAnswersLabel(==180)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *hIncorrectConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-15-[_incorrectAnswersLabel(==_correctAnswersLabel)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *hRankConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-15-[_currentRankLabel(==_correctAnswersLabel)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  
  NSArray *hCardConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-5-[_quizCard(==_correctAnswersLabel)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  
  NSArray *vStatsConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-10-[_correctAnswersLabel(==30)]-5-[_incorrectAnswersLabel(==30)]-5-[_currentRankLabel(==30)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *vStatsBackgroundConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-10-[_correctAnswersBackground(==30)]-5-[_incorrectAnswersBackground(==30)]-5-[_currentRankBackground(==30)][_quizCard]"
                                          options:0
                                          metrics:nil
                                            views:views];
  
  NSArray *vConstrainTopLeftCardContent =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_quizCard]-(-94)-[_leastLabel(==25)][_leastQuizLockButton(==39)]"
                                          options:NSLayoutFormatAlignAllCenterX
                                          metrics:nil
                                            views:views];
  
  NSLayoutConstraint *leastBeginCenterX = [NSLayoutConstraint constraintWithItem:_leastQuizButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_leastQuizLockButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
  NSLayoutConstraint *leastBeginCenterY = [NSLayoutConstraint constraintWithItem:_leastQuizButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_leastQuizLockButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];

  
  self.viewConstraints = [NSMutableArray array];
  [self.viewConstraints addObjectsFromArray:hViewConstraints];
  [self.viewConstraints addObjectsFromArray:vViewConstraints];
  [self.viewConstraints addObjectsFromArray:hPieConstraints];
  [self.viewConstraints addObjectsFromArray:vPieConstraints];
  [self.viewConstraints addObjectsFromArray:hCorrectBackgroundConstraints];
  [self.viewConstraints addObjectsFromArray:hCorrectConstraints];
  [self.viewConstraints addObjectsFromArray:hIncorrectBackgroundConstraints];
  [self.viewConstraints addObjectsFromArray:hIncorrectConstraints];
  [self.viewConstraints addObjectsFromArray:hRankBackgroundConstraints];
  [self.viewConstraints addObjectsFromArray:hRankConstraints];
  [self.viewConstraints addObjectsFromArray:vStatsBackgroundConstraints];
  [self.viewConstraints addObjectsFromArray:vStatsConstraints];
  [self.viewConstraints addObjectsFromArray:vConstrainTopLeftCardContent];
  [self.viewConstraints addObjectsFromArray:@[leastBeginCenterX, leastBeginCenterY]];
  [self.viewConstraints addObjectsFromArray:hCardConstraints]; 
  [self addConstraints:self.viewConstraints];
}

#pragma mark Factory Methods
- (UISegmentedControl *)newSorter{
  UISegmentedControl *sorter = [[UISegmentedControl alloc] initWithItems:@[@"First Name",@"Last Name",@"Index"]];
  [sorter setSelectedSegmentIndex:1];
  [sorter setSegmentedControlStyle:UISegmentedControlStyleBar];
  [sorter setTintColor:[UIColor lightGrayColor]];
  [sorter setTranslatesAutoresizingMaskIntoConstraints:NO];
  [sorter setHidden:YES]; 
  return sorter;
}

-(DLPieChart *)newPieChartView{
  DLPieChart *view = [[DLPieChart alloc] initWithFrame:CGRectMake(0, 0, 120, 120) Center:CGPointMake(0,0) Radius:60];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO]; 
  [view setShowLabel:NO];
  [view setDelegate:self];
  [view setDataSource:self];
  return view; 
}

- (UILabel *)newSummaryLabel{  
  UILabel *label = [[UILabel alloc] init];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

- (UIImageView *)newLabelBackground{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_stattextbar"]];
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imageView;
}

- (UIImageView *)newTopLeftCard{
  UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_topleft_card"]];
  [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardView;
}

- (UILabel *)newLeastLabelWithText:(NSString *)text{
  UILabel *label = [[UILabel alloc] init];
  NSMutableAttributedString *labelAttributes = [[NSMutableAttributedString alloc] initWithString:text];
  
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Regular] range:NSMakeRange(labelAttributes.length-4, 4)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.33f alpha:1.0f] range:NSMakeRange(labelAttributes.length-4,4)];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:13.0f style:Bold] range:NSMakeRange(0,labelAttributes.length-4)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.33f alpha:1.0f] range:NSMakeRange(0,labelAttributes.length-4)];
  [label setAttributedText:labelAttributes];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

- (UIButton *)newQuizLockButton{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_lock_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setBackgroundColor:[UIColor clearColor]];
  return button;
}

- (UIButton *)newQuizBeginButton{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_takequiz_unlocked_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  //todo unhide when the item is purchased.
  [button setHidden:YES];
  [button setBackgroundColor:[UIColor clearColor]];
  return button;
}

#pragma mark Pie Chart Delegate

- (NSUInteger)numberOfSlicesInPieChart:(DLPieChart *)pieChart{
  return 3; 
}
- (CGFloat)pieChart:(DLPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:
                               [NSNumber numberWithFloat:20.0f],
                               [NSNumber numberWithFloat:30.0f],
                               [NSNumber numberWithFloat:50.0f],
                               nil];

  return [[dataArray objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(DLPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *colorArray = [NSMutableArray arrayWithObjects:
                                [UIColor colorWithRed:1.0f green:.71f blue:.20f alpha:1.0f],
                                [UIColor colorWithRed:.29f green:.51f blue:.72f alpha:1.0f],
                                [UIColor colorWithWhite:.33f alpha:1.0f],
                                nil];
  return [colorArray objectAtIndex:index];
}

- (NSString *)pieChart:(DLPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *textArray = [NSMutableArray arrayWithObjects:
                          @"Well",
                          @"Medium",
                          @"Small",
                          nil];
  return [textArray objectAtIndex:index];
}

@end
