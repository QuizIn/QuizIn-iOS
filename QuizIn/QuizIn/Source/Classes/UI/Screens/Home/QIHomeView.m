#import "QIHomeView.h"

@interface QIHomeView ()

//Connections Quiz Start Area
@property(nonatomic, strong) UIView *connectionsQuizStartView;
@property(nonatomic, strong) UIImageView *connectionsQuizPaperImage;
@property(nonatomic, strong) UIImageView *connectionsQuizBinderImage;
@property(nonatomic, strong) UILabel *connectionsQuizTitle;
@property(nonatomic, strong) UILabel *connectionsQuizNumberOfConnectionsLabel;
@property(nonatomic, strong) UIView *connectionsQuizImagePreviewCollection;

//Temporary Buttons
@property(nonatomic, strong, readwrite) UIButton *businessCardQuizButton;
@property(nonatomic, strong, readwrite) UIButton *matchingQuizButton;
@property(nonatomic, strong, readwrite) UIButton *statsViewButton;
@property(nonatomic, strong, readwrite) UIButton *resetStatsButton;
@property(nonatomic, strong, readwrite) UIButton *addStatsButton;
@property(nonatomic, strong, readwrite) UIButton *printStatsButton;

//constraints
@property(nonatomic, strong) NSMutableArray *constraintsForTopLevelViews;
@property(nonatomic, strong) NSMutableArray *constraintsForConnectionsQuizStartView;

@end

@implementation QIHomeView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    //Connections Quiz Start Area Init
    
    _connectionsQuizPaperImage = [self newConnectionsQuizPaperImage];
    _connectionsQuizBinderImage = [self newConnectionsQuizBinderImage];
    _connectionsQuizTitle = [self newConnectionsQuizTitle];
    _connectionsQuizNumberOfConnectionsLabel = [self newConnectionsQuizNumberOfConnectionsLabel];
    _connectionsQuizImagePreviewCollection = [self newConnectionsQuizImagePreviewCollection];
    _connectionsQuizButton = [self newConnectionsQuizButton];
    _connectionsQuizStartView = [self newConnectionsQuizStartView];
    _calendarPickerButton = [self newCalendarPickerButton];
    
    _businessCardQuizButton = [self newBusinessCardQuizButton];
    _matchingQuizButton = [self newMatchingQuizButton];
    _statsViewButton = [self newStatsViewButton];
    _resetStatsButton = [self newResetStatsButton];
    _addStatsButton = [self newAddStatsButton];
    _printStatsButton = [self newPrintStatsButton];
    
    [self constructViewHierachy];
  }
  return self;
}

- (void)constructViewHierachy {
  
  // Construct Connections Quiz Start Area
  [self addSubview:self.calendarPickerButton];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizPaperImage];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizTitle];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizNumberOfConnectionsLabel];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizImagePreviewCollection];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizButton];
  [self addSubview:self.connectionsQuizStartView];
  [self addSubview:self.businessCardQuizButton];
  [self addSubview:self.matchingQuizButton];
  [self addSubview:self.statsViewButton];
  [self addSubview:self.resetStatsButton];
  [self addSubview:self.addStatsButton];
  [self addSubview:self.printStatsButton];

}

#pragma mark Layout
- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraintsForConnectionsQuizStartView) {
    
    //TopLevelView Constraints
    NSDictionary *topLevelViews = NSDictionaryOfVariableBindings(_connectionsQuizStartView);
    
    NSArray *hConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_connectionsQuizStartView(>=200)]-25-|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:topLevelViews];
    NSArray *vConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_connectionsQuizStartView(==250)]-|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:topLevelViews];
    
    self.constraintsForTopLevelViews = [NSMutableArray array];
    [self.constraintsForTopLevelViews  addObjectsFromArray:hConstraintsTopLevelViews];
    [self.constraintsForTopLevelViews  addObjectsFromArray:vConstraintsTopLevelViews];
    [self addConstraints:self.constraintsForTopLevelViews];
    
    //ConnectionsQuizStartView Constraints
    
    NSDictionary *connectionQuizViews = NSDictionaryOfVariableBindings(_connectionsQuizPaperImage,_connectionsQuizBinderImage,_connectionsQuizTitle,_connectionsQuizNumberOfConnectionsLabel,_connectionsQuizImagePreviewCollection,_connectionsQuizButton);
    NSString *primaryVertical = @"V:|-30-[_connectionsQuizTitle][_connectionsQuizNumberOfConnectionsLabel]-[_connectionsQuizImagePreviewCollection(==60)]";
    
    NSArray *vConstraintsConnectionsQuizPaperImageBottom =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizPaperImage]|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSLayoutConstraint *vConstraintsConnectionsQuizPaperImageTop =
    [NSLayoutConstraint constraintWithItem:_connectionsQuizPaperImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_connectionsQuizStartView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-50.0];
     
    
    NSArray *vConstraintsConnectionsQuizButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizButton]-20-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *vConstraintsConnectionsQuizViews =
    [NSLayoutConstraint constraintsWithVisualFormat:primaryVertical
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsPaperImage =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_connectionsQuizPaperImage]|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsTitle =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizTitle]"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsConnectionsLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizNumberOfConnectionsLabel]"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsImagePreview =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizImagePreviewCollection(>=150)]-|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsQuizButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_connectionsQuizButton(>=150)]-30-|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];

    self.constraintsForConnectionsQuizStartView = [NSMutableArray array];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsPaperImage];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsTitle];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsConnectionsLabel];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsImagePreview];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsQuizButton];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:vConstraintsConnectionsQuizViews];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:vConstraintsConnectionsQuizPaperImageBottom];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:@[vConstraintsConnectionsQuizPaperImageTop]];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:vConstraintsConnectionsQuizButton];
    [self.connectionsQuizStartView addConstraints:self.constraintsForConnectionsQuizStartView];
    
    //Constrain calendar Picker Button
    NSDictionary *calendarPickerButtonViews = NSDictionaryOfVariableBindings(_connectionsQuizStartView,_calendarPickerButton);
    
    NSArray *hConstraintsCalendarPickerButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_calendarPickerButton]-30-|"
                                            options:0
                                            metrics:nil
                                              views:calendarPickerButtonViews];
    NSArray *vConstraintsCalendarPickerButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizStartView]-[_calendarPickerButton]"
                                            options:0
                                            metrics:nil
                                              views:calendarPickerButtonViews];
    
    [self addConstraints:hConstraintsCalendarPickerButton];
    [self addConstraints:vConstraintsCalendarPickerButton];
    
    //add Calendar Picker Button TEST
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

#pragma mark Factory Methods

// Setup Connections Quiz Start Area

- (UIImageView *)newConnectionsQuizPaperImage{
  UIImageView *paperImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_paperstack"]];
  [paperImage setTranslatesAutoresizingMaskIntoConstraints:NO];
  return paperImage;
}
- (UIImageView *)newConnectionsQuizBinderImage{
  UIImageView *binderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_paperstack"]];
  [binderImage setTranslatesAutoresizingMaskIntoConstraints:NO];
  return binderImage;
}
- (UILabel *)newConnectionsQuizTitle{
  UILabel *quizTitle = [[UILabel alloc] init];
  quizTitle.text = @"Connections Quiz";
  quizTitle.backgroundColor = [UIColor clearColor];
  [quizTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizTitle;
}
- (UILabel *)newConnectionsQuizNumberOfConnectionsLabel{
  UILabel *quizConnections = [[UILabel alloc] init];
  quizConnections.text = @"865 Connections";
  quizConnections.backgroundColor = [UIColor clearColor];
  [quizConnections setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizConnections;
}
- (UIView *)newConnectionsQuizImagePreviewCollection{
  UIView *previewArea = [[UIView alloc] init];
  previewArea.backgroundColor = [UIColor grayColor];
  [previewArea setTranslatesAutoresizingMaskIntoConstraints:NO];
  return previewArea;
}
- (UIButton *)newConnectionsQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self connectionsQuizButtonTitle] forState:UIControlStateNormal];
  [button setBackgroundImage:[[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 74, 0, 74)] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  button.backgroundColor = [UIColor clearColor];
  return button;
}
- (UIView *)newConnectionsQuizStartView{
  UIView *startView = [[UIView alloc] init];
  [startView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return startView;
}
-(UIButton *)newCalendarPickerButton{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self calendarPickerButtonTitle] forState:UIControlStateNormal];
  [button setBackgroundImage:[[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 74, 0, 74)] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  button.backgroundColor = [UIColor clearColor];
  return button;
}

- (UIButton *)newBusinessCardQuizButton {
  UIButton *businessCardQuizButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [businessCardQuizButton setTitle:@"Business Card" forState:UIControlStateNormal];
  businessCardQuizButton.frame = CGRectMake(10.0f, 330.0f, 150.0f, 44.0f);
  return businessCardQuizButton;
}

- (UIButton *)newMatchingQuizButton {
  UIButton *matchingQuizButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [matchingQuizButton setTitle:@"Matching" forState:UIControlStateNormal];
  matchingQuizButton.frame = CGRectMake(10.0f, 380.0f, 150.0f, 44.0f);
  return matchingQuizButton;
}

- (UIButton *)newStatsViewButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Matching" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 380.0f, 150.0f, 44.0f);
  return statsViewButton;
}

- (UIButton *)newResetStatsButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Reset Stats" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 335.0f, 150.0f, 15.0f);
  return statsViewButton;
}

- (UIButton *)newAddStatsButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Add Stats" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 350.0f, 150.0f, 15.0f);
  return statsViewButton;
}

- (UIButton *)newPrintStatsButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Print Stats" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 365.0f, 150.0f, 15.0f);
  return statsViewButton;
}
#pragma mark Strings

- (NSString *)connectionsQuizButtonTitle {
  return @"Take Quiz";
}
- (NSString *)calendarPickerButtonTitle {
  return @"Group Selection";
}
@end
