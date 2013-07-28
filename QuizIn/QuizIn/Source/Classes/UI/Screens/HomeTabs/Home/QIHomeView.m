#import "QIHomeView.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface QIHomeView ()

@property(nonatomic, strong) UIImageView *viewBackground;

//Connections Quiz Start Area
@property(nonatomic, strong) UIView *connectionsQuizStartView;
@property(nonatomic, strong) UIImageView *connectionsQuizPaperImage;
@property(nonatomic, strong) UIImageView *connectionsQuizBinderImage;
@property(nonatomic, strong) UILabel *connectionsQuizTitle;
@property(nonatomic, strong) UILabel *connectionsQuizNumberOfConnectionsLabel;
@property(nonatomic, strong) UIView *connectionsQuizImagePreviewCollection;
@property(nonatomic, strong) NSArray *profileImages;

//Temporary Buttons
@property(nonatomic, strong, readwrite) UIButton *businessCardQuizButton;
@property(nonatomic, strong, readwrite) UIButton *matchingQuizButton;

//constraints
@property(nonatomic, strong) NSMutableArray *constraintsForTopLevelViews;
@property(nonatomic, strong) NSMutableArray *constraintsForConnectionsQuizStartView;
@property(nonatomic, strong) NSMutableArray *constraintsForImages; 

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
    
    _connectionsQuizPaperImage = [self newConnectionsQuizPaperImage];
    _connectionsQuizBinderImage = [self newConnectionsQuizBinderImage];
    _connectionsQuizTitle = [self newConnectionsQuizTitle];
    _connectionsQuizNumberOfConnectionsLabel = [self newConnectionsQuizNumberOfConnectionsLabel];
    _connectionsQuizImagePreviewCollection = [self newConnectionsQuizImagePreviewCollection];
    _connectionsQuizButton = [self newConnectionsQuizButton];
    _connectionsQuizStartView = [self newConnectionsQuizStartView];
    _calendarPickerButton = [self newCalendarPickerButton];
    _profileImages = [self newProfileImages];
    
    _businessCardQuizButton = [self newBusinessCardQuizButton];
    _matchingQuizButton = [self newMatchingQuizButton];
    
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
  [self addSubview:self.calendarPickerButton];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizPaperImage];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizTitle];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizNumberOfConnectionsLabel];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizImagePreviewCollection];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizButton];
  [self addSubview:self.connectionsQuizStartView];
  [self addSubview:self.businessCardQuizButton];
  [self addSubview:self.matchingQuizButton];
  for (int i= 0; i<4; i++) {
    [self.connectionsQuizImagePreviewCollection addSubview:[self.profileImages objectAtIndex:i]];
  }
}

#pragma mark Layout
- (void)updateConstraints {
  [super updateConstraints];
  //if (!self.constraintsForConnectionsQuizStartView) {
   
    //self constraints
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

    //TopLevelView Constraints
    NSDictionary *topLevelViews = NSDictionaryOfVariableBindings(_connectionsQuizStartView,_viewBackground);
    
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

    NSArray *hConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_connectionsQuizStartView(>=200)]-25-|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:topLevelViews];
    NSArray *vConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_connectionsQuizStartView(==250)]"
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
 // }
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
  quizTitle.text = @"Connections Quiz";
  quizTitle.backgroundColor = [UIColor clearColor];
  [quizTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizTitle;
}
- (UILabel *)newConnectionsQuizNumberOfConnectionsLabel{
  UILabel *quizConnections = [[UILabel alloc] init];
  quizConnections.text = @"Connections";
  quizConnections.backgroundColor = [UIColor clearColor];
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
  matchingQuizButton.frame = CGRectMake(10.0f, 300.0f, 150.0f, 44.0f);
  return matchingQuizButton;
}

- (NSArray *)newProfileImages{
  return @[[self newProfileImageView:nil],[self newProfileImageView:nil],[self newProfileImageView:nil],[self newProfileImageView:nil]];
}

- (AsyncImageView *)newProfileImageView:(NSURL *)imageURL {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  profileImageView.layer.cornerRadius = 4.0f;
  profileImageView.clipsToBounds = YES;
  [profileImageView setImageURL:imageURL];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  return profileImageView;
}

#pragma mark Strings

- (NSString *)connectionsQuizButtonTitle {
  return @"Take Quiz";
}
- (NSString *)calendarPickerButtonTitle {
  return @"Group Selection";
}
@end
