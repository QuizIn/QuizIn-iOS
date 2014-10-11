#import "QIHomeView.h"
#import "QIFontProvider.h"
#import "UIImageView+QIAFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@interface QIHomeView ()
 
@property (nonatomic, strong) UIImageView *viewBackground;

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
@property (nonatomic, strong) UILabel *companyQuizLabel;
@property (nonatomic, strong) UILabel *localeQuizLabel;
@property (nonatomic, strong) UILabel *industryQuizLabel;
@property (nonatomic, strong) UILabel *groupQuizLabel;

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
    _profileImages = [self newProfileImages];
    
    //Group Selection Start View
    _topLeftCard = [self newTopLeftCard];
    _topRightCard = [self newTopRightCard];
    _bottomLeftCard = [self newBottomLeftCard];
    _bottomRightCard = [self newBottomRightCard];
    _companyQuizLockButton = [self newQuizLockButtonWithTag:0];
    _localeQuizLockButton = [self newQuizLockButtonWithTag:4];
    _industryQuizLockButton = [self newQuizLockButtonWithTag:2];
    _groupQuizLockButton = [self newQuizLockButtonWithTag:1];
    _companyQuizBeginButton = [self newQuizBeginButtonWithTag:0];
    _localeQuizBeginButton = [self newQuizBeginButtonWithTag:4];
    _industryQuizBeginButton = [self newQuizBeginButtonWithTag:2];
    _groupQuizBeginButton = [self newQuizBeginButtonWithTag:1];
    _companyQuizLabel = [self newQuizLabelWithText:@"CompanyQuiz"];
    _localeQuizLabel = [self newQuizLabelWithText:@"LocaleQuiz"];
    _industryQuizLabel = [self newQuizLabelWithText:@"IndustryQuiz"];
    _groupQuizLabel = [self newQuizLabelWithText:@"SchoolQuiz"];
    
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

  [self.scrollView addSubview:self.companyQuizBeginButton];
  [self.scrollView addSubview:self.localeQuizBeginButton];
  [self.scrollView addSubview:self.groupQuizBeginButton];
  [self.scrollView addSubview:self.industryQuizBeginButton];
  
  [self.scrollView addSubview:self.companyQuizLockButton];
  [self.scrollView addSubview:self.localeQuizLockButton];
  [self.scrollView addSubview:self.groupQuizLockButton];
  [self.scrollView addSubview:self.industryQuizLockButton];
  
  [self.scrollView addSubview:self.companyQuizLabel];
  [self.scrollView addSubview:self.localeQuizLabel];
  [self.scrollView addSubview:self.groupQuizLabel];
  [self.scrollView addSubview:self.industryQuizLabel];
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraintsForGroupSelectionView){
   
    //scrollView Constraints
    self.constraintsForTopLevelViews = [NSMutableArray array];
    
    NSDictionary *topLevelViews = NSDictionaryOfVariableBindings(_scrollView,_viewBackground);
    
    NSArray *hScrollContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_scrollView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:topLevelViews];
   
    NSArray *vScrollContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_scrollView]-46-|"
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
    NSDictionary *scrollViewViews = NSDictionaryOfVariableBindings(_connectionsQuizStartView);
    
    NSArray *hConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_connectionsQuizStartView(>=200)]-25-|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:scrollViewViews];
    NSArray *vConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[_connectionsQuizStartView(==250)]"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:scrollViewViews];
    
    [self.constraintsForScrollView addObjectsFromArray:hConstraintsTopLevelViews];
    [self.constraintsForScrollView addObjectsFromArray:vConstraintsTopLevelViews];
    [self.scrollView addConstraints:self.constraintsForScrollView];
    
    //ConnectionsQuizStartView Constraints
    
    NSDictionary *connectionQuizViews = NSDictionaryOfVariableBindings(_connectionsQuizPaperImage,_connectionsQuizBinderImage,_connectionsQuizTitle,_connectionsQuizNumberOfConnectionsLabel,_connectionsQuizImagePreviewCollection,_connectionsQuizButton);
    NSString *primaryVertical = @"V:|-35-[_connectionsQuizTitle][_connectionsQuizNumberOfConnectionsLabel]-20-[_connectionsQuizImagePreviewCollection(==60)]";
    
    NSArray *vConstraintsConnectionsQuizPaperImageBottom =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizPaperImage(==250)]"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSLayoutConstraint *vConstraintsConnectionsQuizPaperImageTop =
    [NSLayoutConstraint constraintWithItem:_connectionsQuizPaperImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_connectionsQuizStartView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-20.0];
    
    
    NSArray *vConstraintsConnectionsQuizButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_connectionsQuizButton(==46)]-45-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *vConstraintsConnectionsQuizViews =
    [NSLayoutConstraint constraintsWithVisualFormat:primaryVertical
                                            options:NSLayoutFormatAlignAllCenterX
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
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_profileImage0(==50)]-10-[_profileImage1(==_profileImage0)]-10-[_profileImage2(==_profileImage1)]-10-[_profileImage3(==_profileImage2)]"
                                            options:NSLayoutFormatAlignAllCenterY
                                            metrics:nil
                                              views:imageViews];
    [self.constraintsForImages addObjectsFromArray:hImagesConstraints];
    
    for (int i = 0; i<[_profileImages count]; i++) {
      [self.constraintsForImages addObject:[NSLayoutConstraint constraintWithItem:[_profileImages objectAtIndex:i] attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:[_profileImages objectAtIndex:i] attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
      [self.constraintsForImages addObject:[NSLayoutConstraint constraintWithItem:[_profileImages objectAtIndex:i] attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_connectionsQuizImagePreviewCollection attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    }
    
    [self.connectionsQuizImagePreviewCollection addConstraints:self.constraintsForImages];
    
    //Constain Group Picker Areas
    self.constraintsForGroupSelectionView = [NSMutableArray array];
    NSDictionary *groupSelectionViews = NSDictionaryOfVariableBindings(_topLeftCard,_topRightCard,_bottomLeftCard,_bottomRightCard,_companyQuizLabel,_companyQuizLockButton,_localeQuizLabel,_localeQuizLockButton,_groupQuizLabel,_groupQuizLockButton,_industryQuizLabel,_industryQuizLockButton);
    
    NSArray *hConstrainTopCards =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[_topLeftCard(==163)]-(-8)-[_topRightCard(==_topLeftCard)]-1-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:groupSelectionViews];
    NSArray *hConstrainBottomCards =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-1-[_bottomLeftCard(==_topLeftCard)]-(-8)-[_bottomRightCard(==_bottomLeftCard)]-1-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:groupSelectionViews];
    
    NSArray *vConstrainLeftCards =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topLeftCard(==124)]-(-15)-[_bottomLeftCard(==_topLeftCard)]-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:groupSelectionViews];
    NSArray *vConstrainRightCards =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topRightCard(==_topLeftCard)]-(-15)-[_bottomRightCard(==_topRightCard)]-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:groupSelectionViews];
    
    NSLayoutConstraint *topLeftCardInitialPosition = [NSLayoutConstraint constraintWithItem:_topLeftCard attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_connectionsQuizStartView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-15.0f];
    
    NSArray *vConstrainTopLeftCardContent =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topLeftCard]-(-94)-[_companyQuizLabel(==25)][_companyQuizLockButton(==39)]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:groupSelectionViews];
    NSArray *vConstrainTopRightCardContent =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topRightCard]-(-94)-[_localeQuizLabel(==25)][_localeQuizLockButton(==39)]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:groupSelectionViews];
    NSArray *vConstrainBottomLeftCardContent =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomLeftCard]-(-94)-[_groupQuizLabel(==25)][_groupQuizLockButton(==39)]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:groupSelectionViews];
    NSArray *vConstrainBottomRightCardContent =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomRightCard]-(-94)-[_industryQuizLabel(==25)][_industryQuizLockButton(==39)]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:groupSelectionViews];
    
    NSLayoutConstraint *companyBeginCenterX = [NSLayoutConstraint constraintWithItem:_companyQuizBeginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_companyQuizLockButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *companyBeginCenterY = [NSLayoutConstraint constraintWithItem:_companyQuizBeginButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_companyQuizLockButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *localeBeginCenterX = [NSLayoutConstraint constraintWithItem:_localeQuizBeginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_localeQuizLockButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *localeBeginCenterY = [NSLayoutConstraint constraintWithItem:_localeQuizBeginButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_localeQuizLockButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *groupBeginCenterX = [NSLayoutConstraint constraintWithItem:_groupQuizBeginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_groupQuizLockButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *groupBeginCenterY = [NSLayoutConstraint constraintWithItem:_groupQuizBeginButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_groupQuizLockButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *industryBeginCenterX = [NSLayoutConstraint constraintWithItem:_industryQuizBeginButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_industryQuizLockButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *industryBeginCenterY = [NSLayoutConstraint constraintWithItem:_industryQuizBeginButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_industryQuizLockButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    [self.constraintsForGroupSelectionView addObjectsFromArray:@[topLeftCardInitialPosition]];
    [self.constraintsForGroupSelectionView addObjectsFromArray:@[companyBeginCenterX,companyBeginCenterY,localeBeginCenterX,localeBeginCenterY,groupBeginCenterX,groupBeginCenterY,industryBeginCenterX,industryBeginCenterY]];
    [self.constraintsForGroupSelectionView addObjectsFromArray:hConstrainTopCards];
    [self.constraintsForGroupSelectionView addObjectsFromArray:hConstrainBottomCards];
    [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainLeftCards];
    [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainRightCards];
    [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainTopLeftCardContent];
    [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainTopRightCardContent];
    [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainBottomLeftCardContent];
    [self.constraintsForGroupSelectionView addObjectsFromArray:vConstrainBottomRightCardContent];
    
    [self.scrollView addConstraints:self.constraintsForGroupSelectionView];
  }
}

#pragma mark Data
- (void)updateImages{
  for (NSInteger i=0;i<4;i++) {
    UIImageView *imageView = self.profileImages[i];
    NSURL *url = [self.imageURLs[i] copy];
    
    QI_DECLARE_WEAK_SELF(weakSelf);
    QI_DECLARE_WEAK(imageView, weakImageView);
    [imageView
     setImageWithURL:url
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
       if (!image || !weakSelf || !weakImageView) {
         return;
       }
       dispatch_async(dispatch_get_main_queue(), ^{
         // TODO: (Rene) Activity indicator.
         //  profileImageView.showActivityIndicator = YES;
         CATransition *crossFade = [CATransition animation];
         crossFade.type = kCATransitionFade;
         crossFade.duration = 0.3;
         [weakImageView.layer addAnimation:crossFade forKey:nil];
         weakImageView.image = image;
       });
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
       NSLog(@"Could not load question image in business card quiz view, %@", error);
     }];
  }
}

- (void)updateNumberOfConnections{
  if (self.numberOfConnections == 500){
    [self.connectionsQuizNumberOfConnectionsLabel setText:@"500+ Connections"];
  }
  else{
    [self.connectionsQuizNumberOfConnectionsLabel setText:[NSString stringWithFormat:@"%ld Connections",(long)self.numberOfConnections]];
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
  NSMutableAttributedString *labelAttributes = [[NSMutableAttributedString alloc] initWithString:[self homeViewTitle]];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:16.0f style:Regular] range:NSMakeRange(labelAttributes.length-4, 4)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.33f alpha:1.0f] range:NSMakeRange(labelAttributes.length-4,4)];
  [labelAttributes addAttribute:NSFontAttributeName value:[QIFontProvider fontWithSize:16.0f style:Bold] range:NSMakeRange(0,labelAttributes.length-4)];
  [labelAttributes addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.33f alpha:1.0f] range:NSMakeRange(0,labelAttributes.length-4)];
  [quizTitle setAttributedText:labelAttributes];
  [quizTitle setTextAlignment:NSTextAlignmentCenter];
  [quizTitle setBackgroundColor:[UIColor clearColor]];
  [quizTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizTitle;
}

- (UILabel *)newConnectionsQuizNumberOfConnectionsLabel{
  UILabel *quizConnections = [[UILabel alloc] init];
  [quizConnections setText:[self homeViewSubtext]];
  [quizConnections setFont:[QIFontProvider fontWithSize:13.0f style:Regular]];
  [quizConnections setTextColor:[UIColor colorWithWhite:0.50f alpha:1.0f]];
  [quizConnections setAdjustsFontSizeToFitWidth:YES];
  [quizConnections setBackgroundColor:[UIColor clearColor]];
  [quizConnections setTextAlignment:NSTextAlignmentCenter];
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
  [button setAdjustsImageWhenHighlighted:YES]; 
  [button setBackgroundColor:[UIColor clearColor]];
  return button;
}

- (UIView *)newConnectionsQuizStartView{
  UIView *startView = [[UIView alloc] init];
  [startView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return startView;
}

- (NSArray *)newProfileImages{
  return @[[self newProfileImageView:nil],[self newProfileImageView:nil],[self newProfileImageView:nil],[self newProfileImageView:nil]];
}

- (UIImageView *)newProfileImageView:(NSURL *)imageURL {
  UIImageView *profileImageView = [[UIImageView alloc] init];
  [profileImageView.layer setCornerRadius:4.0f];
  [profileImageView setClipsToBounds:YES];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [profileImageView setContentMode:UIViewContentModeScaleAspectFit];
  
  if (imageURL) {
    QI_DECLARE_WEAK(profileImageView, weakProfileImageView);
    [profileImageView
     setImageWithURL:imageURL
     placeholderImage:nil
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
       if (!image || !weakProfileImageView) {
         return;
       }
       dispatch_async(dispatch_get_main_queue(), ^{
         // TODO: (Rene) Activity indicator.
         //  profileImageView.showActivityIndicator = YES;
         CATransition *crossFade = [CATransition animation];
         crossFade.type = kCATransitionFade;
         crossFade.duration = 0.3;
         [weakProfileImageView.layer addAnimation:crossFade forKey:nil];
         weakProfileImageView.image = image;
       });
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
       NSLog(@"Could not load question image in business card quiz view, %@", error);
     }];
  }

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
  UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_bottomleft_card"]];
  [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardView;
}

- (UIImageView *)newBottomRightCard{
  UIImageView *cardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_bottomright_card"]];
  [cardView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return cardView;
}

- (UIButton *)newQuizLockButtonWithTag:(NSInteger)tag{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_lock_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setAdjustsImageWhenHighlighted:YES];
  [button setBackgroundColor:[UIColor clearColor]];
  [button setTag:tag]; 
  return button;
}

- (UIButton *)newQuizBeginButtonWithTag:(NSInteger)tag{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_takequiz_unlocked_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setAdjustsImageWhenHighlighted:YES];
  [button setHidden:YES];
  [button setBackgroundColor:[UIColor clearColor]];
  return button;
}

- (UILabel *)newQuizLabelWithText:(NSString *)text{
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

#pragma mark Strings
- (NSString *)homeViewTitle{
  return @"ConnectionsQuiz"; 
}
- (NSString *)homeViewSubtext{
  return @"Quiz Using All Connections";
}

@end
