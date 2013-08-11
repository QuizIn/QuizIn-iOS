#import "QIHomeView.h"
#import "AsyncImageView.h"
#import "QIFontProvider.h"
#import <QuartzCore/QuartzCore.h>

@interface QIHomeView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) UIScrollView *scrollView; 

//Connections Quiz Start Area
@property (nonatomic, strong) UIView *connectionsQuizStartView;
@property (nonatomic, strong) UIImageView *connectionsQuizPaperImage;
@property (nonatomic, strong) UIImageView *connectionsQuizBinderImage;
@property (nonatomic, strong) UILabel *connectionsQuizTitle;
@property (nonatomic, strong) UILabel *connectionsQuizNumberOfConnectionsLabel;
@property (nonatomic, strong) UIView *connectionsQuizImagePreviewCollection;
@property (nonatomic, strong) NSArray *profileImages;

//Group Selection Area
@property (nonatomic, strong) UIImageView *topLeftCard;
@property (nonatomic, strong) UIImageView *topRightCard;
@property (nonatomic, strong) UIImageView *bottomLeftCard;
@property (nonatomic, strong) UIImageView *bottomRightCard;

//constraints
@property (nonatomic, strong) NSMutableArray *constraintsForScrollView; 
@property (nonatomic, strong) NSMutableArray *constraintsForTopLevelViews;
@property (nonatomic, strong) NSMutableArray *constraintsForConnectionsQuizStartView;
@property (nonatomic, strong) NSMutableArray *constraintsForGroupSelectionView; 
@property (nonatomic, strong) NSMutableArray *constraintsForImages; 

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
    _viewBackground = [self newViewBackground];
    _scrollView = [self newScrollView];
    
    //Connections Quiz Start View
    _connectionsQuizPaperImage = [self newConnectionsQuizPaperImage];
    _connectionsQuizBinderImage = [self newConnectionsQuizBinderImage];
    _connectionsQuizTitle = [self newConnectionsQuizTitle];
    _connectionsQuizNumberOfConnectionsLabel = [self newConnectionsQuizNumberOfConnectionsLabel];
    _connectionsQuizImagePreviewCollection = [self newConnectionsQuizImagePreviewCollection];
    _connectionsQuizButton = [self newConnectionsQuizButton];
    _connectionsQuizStartView = [self newConnectionsQuizStartView];
    _calendarPickerButton = [self newCalendarPickerButton];
    _profileImages = [self newProfileImages];
    
    //Group Selection Start View
    _topLeftCard = [self newTopLeftCard];
    _topRightCard = [self newTopRightCard];
    _bottomLeftCard = [self newBottomLeftCard];
    _bottomRightCard = [self newBottomRightCard];

    [self constructViewHierachy];
  }
  return self;
}

#pragma mark Properties
- (void)setImageURLs:(NSArray *)imageURLs{
  if([self.imageURLs isEqualToArray:imageURLs]){
    return;
  }
  _imageURLs = [imageURLs copy];
  [self updateImages];
}

- (void)setNumberOfConnections:(NSInteger)numberOfConnections{
  _numberOfConnections = numberOfConnections;
  [self updateNumberOfConnections];
}

- (void)constructViewHierachy {
  
  // Construct Connections Quiz Start Area
  [self addSubview:self.viewBackground];
  [self addSubview:self.scrollView];

  [self.scrollView addSubview:self.calendarPickerButton];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizPaperImage];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizTitle];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizNumberOfConnectionsLabel];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizImagePreviewCollection];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizButton];
  [self.scrollView addSubview:self.connectionsQuizStartView];

  for (int i= 0; i<4; i++) {
    [self.connectionsQuizImagePreviewCollection addSubview:[self.profileImages objectAtIndex:i]];
  }
  
  //Construct the Group selection view area
  [self.scrollView addSubview:self.topLeftCard];
  [self.scrollView addSubview:self.topRightCard];
  [self.scrollView addSubview:self.bottomLeftCard];
  [self.scrollView addSubview:self.bottomRightCard];
}

#pragma mark Layout
- (void)updateConstraints {
  [super updateConstraints];
  
  
  //self constraints
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
  
  //scrollView Constraints
  self.constraintsForTopLevelViews = [NSMutableArray array];
  
  NSDictionary *topLevelViews = NSDictionaryOfVariableBindings(_scrollView,_viewBackground);
  
  NSArray *hScrollContraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_scrollView]|"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:topLevelViews];
  NSArray *vScrollContraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_scrollView]|"
                                          options:NSLayoutFormatAlignAllLeft
                                          metrics:nil
                                            views:topLevelViews];
  NSArray *hBackgroundContraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:topLevelViews];
  NSArray *vBackgroundContraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                          options:NSLayoutFormatAlignAllLeft
                                          metrics:nil
                                            views:topLevelViews];
  
  [self.constraintsForTopLevelViews addObjectsFromArray:hBackgroundContraints];
  [self.constraintsForTopLevelViews addObjectsFromArray:vBackgroundContraints];
  [self.constraintsForTopLevelViews addObjectsFromArray:hScrollContraints];
  [self.constraintsForTopLevelViews addObjectsFromArray:vScrollContraints];
  
  [self addConstraints:self.constraintsForTopLevelViews];
  
  //TopLevelView Constraints
  self.constraintsForScrollView = [NSMutableArray array];
  NSDictionary *scrollViewViews = NSDictionaryOfVariableBindings(_connectionsQuizStartView,_calendarPickerButton);
  
  NSArray *hConstraintsCalendarPickerButton =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_calendarPickerButton]-30-|"
                                          options:0
                                          metrics:nil
                                            views:scrollViewViews];
  NSArray *vConstraintsCalendarPickerButton =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizStartView]-[_calendarPickerButton]"
                                          options:0
                                          metrics:nil
                                            views:scrollViewViews];
  
  NSArray *hConstraintsTopLevelViews =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_connectionsQuizStartView(>=200)]-25-|"
                                          options:NSLayoutFormatAlignAllBaseline
                                          metrics:nil
                                            views:scrollViewViews];
  NSArray *vConstraintsTopLevelViews =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_connectionsQuizStartView(==250)]"
                                          options:NSLayoutFormatAlignAllBaseline
                                          metrics:nil
                                            views:scrollViewViews];
  
  [self.constraintsForScrollView addObjectsFromArray:hConstraintsCalendarPickerButton];
  [self.constraintsForScrollView addObjectsFromArray:vConstraintsCalendarPickerButton]; 
  [self.constraintsForScrollView addObjectsFromArray:hConstraintsTopLevelViews];
  [self.constraintsForScrollView addObjectsFromArray:vConstraintsTopLevelViews];
  [self.scrollView addConstraints:self.constraintsForScrollView];
  
  //ConnectionsQuizStartView Constraints
  
  NSDictionary *connectionQuizViews = NSDictionaryOfVariableBindings(_connectionsQuizPaperImage,_connectionsQuizBinderImage,_connectionsQuizTitle,_connectionsQuizNumberOfConnectionsLabel,_connectionsQuizImagePreviewCollection,_connectionsQuizButton);
  NSString *primaryVertical = @"V:|-40-[_connectionsQuizTitle][_connectionsQuizNumberOfConnectionsLabel]-30-[_connectionsQuizImagePreviewCollection(==60)]";
  
  NSArray *vConstraintsConnectionsQuizPaperImageBottom =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizPaperImage]|"
                                          options:NSLayoutFormatAlignAllLeft
                                          metrics:nil
                                            views:connectionQuizViews];
  
  NSLayoutConstraint *vConstraintsConnectionsQuizPaperImageTop =
  [NSLayoutConstraint constraintWithItem:_connectionsQuizPaperImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_connectionsQuizStartView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-20.0];
  
  
  NSArray *vConstraintsConnectionsQuizButton =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizButton(==46)]-25-|"
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
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-29-[_connectionsQuizButton(==212)]-29-|"
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
  
  //Constrain Image View
  self.constraintsForImages = [NSMutableArray array];
  NSDictionary *imageViews = [NSDictionary dictionaryWithObjectsAndKeys:
                              [_profileImages objectAtIndex:0], @"_profileImage0",
                              [_profileImages objectAtIndex:1], @"_profileImage1",
                              [_profileImages objectAtIndex:2], @"_profileImage2",
                              [_profileImages objectAtIndex:3], @"_profileImage3",
                              nil];
  
  NSArray *hImagesConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_profileImage0(==50)]-5-[_profileImage1(==_profileImage0)]-5-[_profileImage2(==_profileImage1)]-5-[_profileImage3(==_profileImage2)]"
                                          options:NSLayoutFormatAlignAllCenterY
                                          metrics:nil
                                            views:imageViews];
  [self.constraintsForImages addObjectsFromArray:hImagesConstraints];
  
  for (int i = 0; i<[_profileImages count]; i++) {
    [self.constraintsForImages addObject:[NSLayoutConstraint constraintWithItem:[_profileImages objectAtIndex:i] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[_profileImages objectAtIndex:i] attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
  }
  
  [self.connectionsQuizImagePreviewCollection addConstraints:self.constraintsForImages];
  
  //Constain Group Picker Areas
  self.constraintsForGroupSelectionView = [NSMutableArray array];
  NSDictionary *groupSelectionViews = NSDictionaryOfVariableBindings(_topLeftCard,_topRightCard,_bottomLeftCard,_bottomRightCard);
  
  NSArray *hConstrainTopCards =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-2)-[_topLeftCard(==163)]-(-2)-[_topRightCard(==_topLeftCard)]-(-2)-|"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:groupSelectionViews];
  NSArray *hConstrainBottomCards =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-2)-[_bottomLeftCard(==_topLeftCard)]-(-2)-[_bottomRightCard(==_bottomLeftCard)]-(-2)-|"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:groupSelectionViews];
  
  NSArray *vConstrainLeftCards =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topLeftCard(==124)]-(-10)-[_bottomLeftCard(==_topLeftCard)]"
                                          options:NSLayoutFormatAlignAllLeft
                                          metrics:nil
                                            views:groupSelectionViews];
  NSArray *vConstrainRightCards = 
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topRightCard(==_topLeftCard)]-(-10)-[_bottomRightCard(==_topRightCard)]"
                                          options:NSLayoutFormatAlignAllLeft
                                          metrics:nil
                                            views:groupSelectionViews];
  
  NSLayoutConstraint *topLeftCardInitialPosition = [NSLayoutConstraint constraintWithItem:_topLeftCard attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_connectionsQuizStartView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-5.0f];
  
  [self.constraintsForGroupSelectionView addObjectsFromArray:@[topLeftCardInitialPosition]]; 
  [self.constraintsForGroupSelectionView addObjectsFromArray:hConstrainTopCards];
  [self.constraintsForGroupSelectionView addObjectsFromArray:hConstrainBottomCards];
  [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainLeftCards];
  [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainRightCards];
  
  [self.scrollView addConstraints:self.constraintsForGroupSelectionView]; 

}

- (void)layoutSubviews {
  [super layoutSubviews];
}
#pragma mark Data
- (void)updateImages{
  for (int i=0;i<4;i++) {
    AsyncImageView *image = [self.profileImages objectAtIndex:i];
    NSURL *url = [self.imageURLs objectAtIndex:i];
    [image setImageURL:url];
  }
}

- (void)updateNumberOfConnections{
  if (self.numberOfConnections == 500){
    [self.connectionsQuizNumberOfConnectionsLabel setText:@"500+ Connections"];
  }
  else{
    [self.connectionsQuizNumberOfConnectionsLabel setText:[NSString stringWithFormat:@"%d Connections",self.numberOfConnections]];
  }
}

#pragma mark Factory Methods

// Setup Connections Quiz Start Area
-(UIScrollView *)newScrollView{
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  [scrollView setDelegate:self];
  [scrollView setBackgroundColor:[UIColor clearColor]];
  [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [scrollView setPagingEnabled:NO];
  [scrollView setShowsHorizontalScrollIndicator:NO];
  [scrollView setShowsVerticalScrollIndicator:NO];
  [scrollView setBouncesZoom:NO];
  [scrollView setBounces:YES];
  [scrollView setDirectionalLockEnabled:YES];
  [scrollView setAlwaysBounceVertical:YES];
  [scrollView setAlwaysBounceHorizontal:NO];
  return scrollView;
}

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

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
  [quizTitle setText:[self homeViewTitle]];
  [quizTitle setFont:[QIFontProvider fontWithSize:16.0f style:Bold]];
  [quizTitle setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0f]];
  [quizTitle setAdjustsFontSizeToFitWidth:YES];
  [quizTitle setBackgroundColor:[UIColor clearColor]];
  [quizTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizTitle;
}

- (UILabel *)newConnectionsQuizNumberOfConnectionsLabel{
  UILabel *quizConnections = [[UILabel alloc] init];
  [quizConnections setText:[self homeViewSubtext]];
  [quizConnections setFont:[QIFontProvider fontWithSize:13.0f style:Regular]];
  [quizConnections setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0f]];
  [quizConnections setAdjustsFontSizeToFitWidth:YES];
  [quizConnections setBackgroundColor:[UIColor clearColor]];
  [quizConnections setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizConnections;
}

- (UIView *)newConnectionsQuizImagePreviewCollection{
  UIView *previewArea = [[UIView alloc] init];
  [previewArea setTranslatesAutoresizingMaskIntoConstraints:NO];
  return previewArea;
}

- (UIButton *)newConnectionsQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_hobnob_btn"] forState:UIControlStateNormal];
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
  [button setBackgroundColor:[UIColor clearColor]];
  return button;
}

- (NSArray *)newProfileImages{
  return @[[self newProfileImageView:nil],[self newProfileImageView:nil],[self newProfileImageView:nil],[self newProfileImageView:nil]];
}

- (AsyncImageView *)newProfileImageView:(NSURL *)imageURL {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView.layer setCornerRadius:4.0f];
  [profileImageView setClipsToBounds:YES];
  [profileImageView setImageURL:imageURL];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [profileImageView setContentMode:UIViewContentModeScaleAspectFit];
  [profileImageView setShowActivityIndicator:YES];
  [profileImageView setCrossfadeDuration:0.3f];
  [profileImageView setCrossfadeImages:YES];
  return profileImageView;
}

- (UIImageView *)newTopLeftCard{
  UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_topleft_card"]];
  [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardView;
}

- (UIImageView *)newTopRightCard{
  UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_topright_card"]];
  [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardView;
}

- (UIImageView *)newBottomLeftCard{
  UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_topright_card"]];
  [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardView;
}

- (UIImageView *)newBottomRightCard{
  UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_bottomright_card"]];
  [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardView;
}

#pragma mark Strings
- (NSString *)homeViewTitle{
  return @"Connections Quiz"; 
}
- (NSString *)homeViewSubtext{
  return @"Connections"; 
}

- (NSString *)calendarPickerButtonTitle {
  return @"Group Selection";
}
@end
