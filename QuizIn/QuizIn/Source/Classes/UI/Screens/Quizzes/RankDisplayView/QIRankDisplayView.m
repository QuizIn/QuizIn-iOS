#import "QIRankDisplayView.h"
#import "QIFontProvider.h"
#import "QIRankDefinition.h"
#import "QIStatsData.h"
#import "UIImageView+QIAFNetworking.h"

@interface QIRankDisplayView ()

@property (nonatomic, strong) UILabel *lockedStatusLabel; 
@property (nonatomic, strong) UILabel *rankDescriptionLabel;
@property (nonatomic, strong) UILabel *nameLabel; 
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *rankBadgeImage;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) NSMutableArray *rankDisplayViewConstraints;

@end

@implementation QIRankDisplayView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _lockedStatusLabel = [self newLockedStatusLabel]; 
    _backgroundImage = [self newBackgroundImage];
    _rankDescriptionLabel = [self newRankDescriptionLabel];
    _rankBadgeImage = [self newRankBadgeImage];
    _profileImageView = [self newProfileImageView];
    _nameLabel = [self newNameLabel]; 
    _fbShareButton = [self newRankShareButtonWithSharingIndex:0];
    _twitterShareButton = [self newRankShareButtonWithSharingIndex:1];
    _linkedInShareButton = [self newRankShareButtonWithSharingIndex:2];
    _exitButton = [self newExitButton]; 
    [self constructViewHierarchy];
  }
  return self;
}

#pragma mark Properties

- (void) setRank:(int)rank {
  _rank = rank;
  [self updateRankBadgeImage];
  [self updateRankDescription];
  
}

- (void) setUserID:(NSString *)userID{
  _userID = userID;
  [self updateLockedStatusLabel]; 
}

- (void)setProfileImageURL:(NSURL *)profileImageURL{
  _profileImageURL = profileImageURL; 
  [self updateProfileImageView];
}

- (void)setProfileName:(NSString *)profileName{
  _profileName = profileName;
  [self updateProfileNameLabel];
}

#pragma mark Data Update

- (void) updateRankBadgeImage{
  self.rankBadgeImage.image = [QIRankDefinition getRankBadgeForRank:self.rank];
}

- (void) updateRankDescription{
  self.rankDescriptionLabel.text = [QIRankDefinition getRankDescriptionForRank:self.rank];
}

- (void) updateLockedStatusLabel{
  QIStatsData *stats = [[QIStatsData alloc] initWithLoggedInUserID:self.userID];
  int currentRank = [stats getCurrentRank];
  if (currentRank >= self.rank){
    self.lockedStatusLabel.text = [self lockedStatusText:NO];
  }
  else{
    self.lockedStatusLabel.text = [self lockedStatusText:YES];
  }
}

- (void)updateProfileImageView {
  if (!self.profileImageURL) {
    return;
  }
  
  QI_DECLARE_WEAK_SELF(weakSelf);
  [self.profileImageView
   setImageWithURL:self.profileImageURL
   placeholderImage:nil
   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
     if (!image || !weakSelf || !weakSelf.profileImageView) {
       return;
     }
     dispatch_async(dispatch_get_main_queue(), ^{
       // TODO: (Rene) Crossfade in?
       weakSelf.profileImageView.image = image;
     });
   }
   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
     NSLog(@"Could not load question image in business card quiz view, %@", error);
   }];
}

- (void)updateProfileNameLabel{
  [self.nameLabel setText:self.profileName]; 
}

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self addSubview:self.backgroundImage];
  [self addSubview:self.lockedStatusLabel];
  [self addSubview:self.rankDescriptionLabel];
  [self addSubview:self.rankBadgeImage];
  [self addSubview:self.profileImageView];
  [self addSubview:self.nameLabel]; 
  [self addSubview:self.fbShareButton];
  [self addSubview:self.twitterShareButton];
  [self addSubview:self.linkedInShareButton];
  [self addSubview:self.exitButton]; 
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.rankDisplayViewConstraints) {
    
    self.rankDisplayViewConstraints = [NSMutableArray array];
    //Constrain Background Image
    NSDictionary *rankViews = NSDictionaryOfVariableBindings(_backgroundImage,_lockedStatusLabel,_rankBadgeImage,_rankDescriptionLabel,_fbShareButton,_twitterShareButton,_linkedInShareButton,_profileImageView,_nameLabel,_exitButton);
    
    NSArray *hLockedLabelStatus =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_lockedStatusLabel]|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *hBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[_backgroundImage(==263)]-29-|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *hExit=
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_backgroundImage]-(-28)-[_exitButton(==28)]"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *vExit =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_exitButton(==20)]"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *hShareButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-57-[_fbShareButton(==55)]-20-[_twitterShareButton(==_fbShareButton)]-20-[_linkedInShareButton(==_fbShareButton)]"
                                            options:NSLayoutFormatAlignAllBottom
                                            metrics:nil
                                              views:rankViews];
    NSArray *vAll =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_lockedStatusLabel(==30)][_backgroundImage]-10-[_twitterShareButton]"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *hRankElements =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_rankBadgeImage(==120)]-45-|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    
    NSArray *hProfileImage =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-47-[_profileImageView(==80)]-(-80)-[_nameLabel]"
                                            options:0
                                            metrics:nil
                                              views:rankViews];

    NSArray *vProfileImage =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-49-[_profileImageView(==80)]-10-[_nameLabel(==20)]"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *vRankBadge =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_lockedStatusLabel]-2-[_rankBadgeImage(==120)]"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    
    NSArray *hRankLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rankDescriptionLabel]-34-|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *vRankLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rankDescriptionLabel(==30)]-38-|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    
    [self.rankDisplayViewConstraints addObjectsFromArray:hShareButton]; 
    [self.rankDisplayViewConstraints addObjectsFromArray:hBackground];
    [self.rankDisplayViewConstraints addObjectsFromArray:vAll];
    [self.rankDisplayViewConstraints addObjectsFromArray:hLockedLabelStatus]; 
    [self.rankDisplayViewConstraints addObjectsFromArray:hRankElements];
    [self.rankDisplayViewConstraints addObjectsFromArray:vRankBadge];
    [self.rankDisplayViewConstraints addObjectsFromArray:hProfileImage];
    [self.rankDisplayViewConstraints addObjectsFromArray:vProfileImage];
    [self.rankDisplayViewConstraints addObjectsFromArray:hExit];
    [self.rankDisplayViewConstraints addObjectsFromArray:vExit];
    [self.rankDisplayViewConstraints addObjectsFromArray:vRankLabel];
    [self.rankDisplayViewConstraints addObjectsFromArray:hRankLabel];
    
    [self addConstraints:self.rankDisplayViewConstraints];
  }
}
#pragma mark Strings
-(NSString *)lockedStatusText:(BOOL)locked{
  if (locked){
    return @"Locked";
  }
  else{
    return @"Unlocked!";
  }
}

#pragma mark Factory Methods

- (UILabel *)newLockedStatusLabel {
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:20.0f style:Bold]];
  [label setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setText:[self lockedStatusText:YES]]; 
  return label;
}

-(UIImageView *)newBackgroundImage{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hobnob_ranking_popup_card"]];
  [imageView setContentMode:UIViewContentModeScaleToFill];
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imageView;
}

-(UIImageView *)newRankBadgeImage{
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView setContentMode:UIViewContentModeScaleAspectFill];
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imageView;
}

-(UIImageView *)newProfileImageView{
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView setContentMode:UIViewContentModeScaleAspectFill];
  [imageView setBackgroundColor:[UIColor blackColor]]; 
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [imageView setImage:[UIImage imageNamed:@"placeholderHead"]];
  
  return imageView;
}

- (UILabel *)newRankDescriptionLabel {
  UILabel *resultLabel = [[UILabel alloc] init];
  [resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [resultLabel setBackgroundColor:[UIColor clearColor]];
  [resultLabel setFont:[QIFontProvider fontWithSize:12.0f style:Bold]];
  [resultLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  [resultLabel setTextAlignment:NSTextAlignmentRight]; 
  return resultLabel;
}

- (UILabel *)newNameLabel {
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:12.0f style:Bold]];
  [label setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentLeft];
  [label setText:@"Your Name"];
  return label;
}

- (UIButton *)newRankShareButtonWithSharingIndex:(NSInteger)index {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  
  switch (index) {
    case 0:
      [button setBackgroundImage:[UIImage imageNamed:@"hobnob_ranking_popup_facebook_btn"] forState:UIControlStateNormal];
      break;
    case 1:
      [button setBackgroundImage:[UIImage imageNamed:@"hobnob_ranking_popup_twitter_btn"] forState:UIControlStateNormal];
      break;
    case 2:
      [button setBackgroundImage:[UIImage imageNamed:@"hobnob_ranking_popup_linkedin_btn"] forState:UIControlStateNormal];
      break;
    default:
      break;
  }
  
  [button setContentMode:UIViewContentModeScaleAspectFill];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

- (UIButton *)newExitButton {
  UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [exitButton setImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateNormal];
  [exitButton setAlpha:0.8f];
  [exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return exitButton;
}

@end