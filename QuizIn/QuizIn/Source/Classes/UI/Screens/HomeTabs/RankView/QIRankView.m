#import "QIRankView.h"
#import "QIRankDefinition.h"

@interface QIRankView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) UIImageView *rankSign; 
@property (nonatomic, strong) UIView *overlayMask;

@property (nonatomic, strong) NSMutableArray *rankButtons;
@property (nonatomic, strong) NSArray *rankDelineations;
@property (nonatomic, strong) NSArray *rankBadges;
@property (nonatomic, strong) NSArray *rankDescriptions;

@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic, strong) NSMutableArray *scrollViewContstraints;
@property (nonatomic, strong) NSLayoutConstraint *topRank;

@end

@implementation QIRankView
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _viewBackground = [self newViewBackground];
    _rankSign = [self newRankSign];
    _scrollView = [self newScrollView];
    _overlayMask = [self newOverlayMask];
    _rankDisplayView = [self newRankDisplayView]; 
    _rankDelineations = [QIRankDefinition getRankDelineations];
    _rankBadges = [QIRankDefinition getAllRankBadges];
    _rankDescriptions = [QIRankDefinition getAllRankDescriptions];
    _rankButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i<[_rankBadges count]; i++){
      [_rankButtons addObject:[self newRankButtonWithImage:[_rankBadges objectAtIndex:i] forTag:i]];
    }
    
    [self constructViewHierarchy];
  }
  return self;
}

#pragma mark Properties

- (void)setRank:(NSString *)rank{
  _rank = rank;
  [self updateRankButtonStates]; 
}

- (void)setUserID:(NSString *)userID{
  _userID = userID;
  _rankDisplayView.userID = userID; 
}

#pragma mark Layout
- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground];
  for (UIButton *button in self.rankButtons){
    [self.scrollView addSubview:button];
  }
  [self.scrollView addSubview:self.rankSign]; 
  [self addSubview:self.scrollView];
  [self addSubview:self.overlayMask];
  [self addSubview:self.rankDisplayView];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.viewConstraints) {
    
    // Constrain Base Views
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground, _scrollView,_overlayMask,_rankSign);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    NSArray *hScrollContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_scrollView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    NSArray *vScrollContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-20-[_scrollView]|"
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
    
    self.viewConstraints = [NSMutableArray array];
    [self.viewConstraints addObjectsFromArray:hBackgroundContraints];
    [self.viewConstraints addObjectsFromArray:vBackgroundContraints];
    [self.viewConstraints addObjectsFromArray:hScrollContraints];
    [self.viewConstraints addObjectsFromArray:vScrollContraints];
    [self.viewConstraints addObjectsFromArray:hOverlayContraints];
    [self.viewConstraints addObjectsFromArray:vOverlayContraints];
    
    //Contrain ScrollViews
  
    self.scrollViewContstraints = [NSMutableArray array];
    
    //Rank Sign
    NSArray *hSignContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-63-[_rankSign]-63-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vSignContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_rankSign(==112)]"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    [self.scrollViewContstraints addObjectsFromArray:hSignContraints];
    [self.scrollViewContstraints addObjectsFromArray:vSignContraints];

    //Button Size
    for (UIButton *button in self.rankButtons){
      [self.scrollViewContstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:104.0f]];
      [self.scrollViewContstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    }
    
    //Button Placement
    for (int i=0; i<[self.rankButtons count]; i=i+2){
      UIButton *button = [self.rankButtons objectAtIndex:i];
      UIButton *button1 = [self.rankButtons objectAtIndex:i+1];
      [self.scrollViewContstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:button1 attribute:NSLayoutAttributeLeft multiplier:1.0f constant:-42.0f]];
      [self.scrollViewContstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button1 attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
      [self.scrollViewContstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:(i/2)*104+130]];
      [self.scrollViewContstraints addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:36.0f]];
    }
    
    [self.scrollViewContstraints addObject:[NSLayoutConstraint constraintWithItem:[self.rankButtons lastObject] attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    
    //Constrain Rank Display
    NSLayoutConstraint *centerRankX = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *heightRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:220.0f];
    
    _topRank = [NSLayoutConstraint constraintWithItem:_rankDisplayView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:-220.0f];
    
    [self.viewConstraints addObjectsFromArray:@[centerRankX,widthRank,heightRank,_topRank]];
    
    [self.scrollView addConstraints:self.scrollViewContstraints];
    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark Actions

-(void)showRankDisplay:(id)sender{
  UIButton *button = (UIButton *)sender;
  self.rankDisplayView.rank = button.tag;
  self.rankDisplayView.userID = self.userID; 
  [UIView animateWithDuration:0.5 animations:^{
    [self.topRank setConstant:100.0f];
    [self.overlayMask setHidden:NO];
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

-(void)updateRankButtonStates{
 self.rankBadges = [QIRankDefinition getAllRankBadges];
  for (int i = 0; i<[self.rankButtons count]; i++){
    [[self.rankButtons objectAtIndex:i] setBackgroundImage:[self.rankBadges objectAtIndex:i]forState:UIControlStateNormal];
  }
}

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UIImageView *)newRankSign{
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hobnob_rankings_title"]];
  [image setTranslatesAutoresizingMaskIntoConstraints:NO];
  return image;
}

- (QIRankDisplayView *)newRankDisplayView{
  QIRankDisplayView *view = [[QIRankDisplayView alloc] init];
  [view setRank:1]; 
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  [view setBackgroundColor:[UIColor clearColor]];
  return view;
}

- (UIScrollView *)newScrollView{
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

- (UIView *)newOverlayMask{
  UIView *view = [[UIView alloc] init];
  [view setHidden:YES];
  [view setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:.8f]];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  return view;
}

- (UIButton *)newRankButtonWithImage:(UIImage *)image forTag:(NSInteger)tag{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:image forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setBackgroundColor:[UIColor clearColor]];
  [button setTag:tag];
  [button addTarget:self action:@selector(showRankDisplay:) forControlEvents:UIControlEventTouchUpInside];
  return button; 
}


@end
