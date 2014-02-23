
#import "QIStatsCellView.h"
#import "QIFontProvider.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface QIStatsCellView ()

@property (nonatomic, strong) UILabel *connectionNameLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *wrongLabel;
@property (nonatomic, strong) UIImageView *trendImage;
@property (nonatomic, strong) UIView *keyKnown; 
@property (nonatomic, strong) AsyncImageView *profileImageView;
@property (nonatomic, strong) NSMutableArray *cellViewConstraints;

@end

@implementation QIStatsCellView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _connectionNameLabel = [self newConnectionNameLabel];
      _rightLabel = [self newKnowledgeIndexLabel];
      _wrongLabel = [self newKnowledgeIndexLabel];
      _trendImage = [self newTrendImage];
      _keyKnown = [self newKeyKnownView];
      _profileImageView = [self newProfileImageView];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma properties

- (void)setProfileImageURL:(NSURL *)profileImageURL{
  _profileImageURL = profileImageURL;
  [self updateProfileImage];
}

- (void)setConnectionName:(NSString *)connectionName{
  if ([self.connectionName isEqualToString:connectionName]){
    return;
  }
  _connectionName = connectionName;
  [self updateConnectionNameLabel];
}

- (void)setRightAnswers:(NSString *)rightAnswers{
  _rightAnswers = rightAnswers;
  [self updateRightAnswers];
}

- (void)setWrongAnswers:(NSString *)wrongAnswers{
  _wrongAnswers = wrongAnswers;
  [self updateWrongAnswers];
}

- (void)setUpTrend:(BOOL)upTrend{
  _upTrend = upTrend;
  [self updateTrendImage];
}

- (void)setKeyColorIndex:(NSInteger )keyColorIndex{
  _keyColorIndex = keyColorIndex;
  [self updateKeyColor];
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self.contentView addSubview:self.connectionNameLabel];
  [self.contentView addSubview:self.rightLabel];
  [self.contentView addSubview:self.wrongLabel];
  [self.contentView addSubview:self.trendImage];
  [self.contentView addSubview:self.keyKnown]; 
  [self.contentView addSubview:self.profileImageView];
}

#pragma mark Update
-(void)updateProfileImage{
  [self.profileImageView setImageURL:self.profileImageURL];
}

- (void)updateConnectionNameLabel{
  [self.connectionNameLabel setText:self.connectionName];
}

- (void)updateRightAnswers{
  [self.rightLabel setText:self.rightAnswers];
}

- (void)updateWrongAnswers{
  [self.wrongLabel setText:self.wrongAnswers];
}

- (void)updateTrendImage{
  if (self.upTrend)
    [self.trendImage setImage:[UIImage imageNamed:@"up_arrow_icon"]];
  else
    [self.trendImage setImage:[UIImage imageNamed:@"down_arrow_icon"]];
}

- (void)updateKeyColor{
  switch (self.keyColorIndex) {
    case 0:
      [self.keyKnown setBackgroundColor:[UIColor colorWithRed:1.0f green:.71f blue:.20f alpha:1.0f]];
      break;
    case 1:
      [self.keyKnown setBackgroundColor:[UIColor colorWithRed:.29f green:.51f blue:.72f alpha:1.0f]];
      break;
    case 2:
      [self.keyKnown setBackgroundColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
      break;
    default:
      break;
  }
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.cellViewConstraints) {
    
     self.cellViewConstraints = [NSMutableArray array];
    
    //Constrain CellView
    NSDictionary *cellViews = NSDictionaryOfVariableBindings(_connectionNameLabel,_profileImageView,_rightLabel,_wrongLabel,_trendImage,_keyKnown);
    
    NSArray *hCellViewsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-3-[_profileImageView(==40)]-3-[_connectionNameLabel(>=100)]-4-[_rightLabel(==30)][_wrongLabel(==30)]-2-[_trendImage(==25)]-9-[_keyKnown(==18)]-16-|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vImageViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-3-[_profileImageView]-3-|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_connectionNameLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vRightConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_rightLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vWrongConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_wrongLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vTrendConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-15-[_trendImage]-15-|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vKeyConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-14-[_keyKnown]-14-|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    
    [self.cellViewConstraints addObjectsFromArray:hCellViewsConstraints];
    [self.cellViewConstraints addObjectsFromArray:vImageViewConstraints];
    [self.cellViewConstraints addObjectsFromArray:vNameConstraints];
    [self.cellViewConstraints addObjectsFromArray:vRightConstraints];
    [self.cellViewConstraints addObjectsFromArray:vWrongConstraints];
    [self.cellViewConstraints addObjectsFromArray:vTrendConstraints];
    [self.cellViewConstraints addObjectsFromArray:vKeyConstraints];
    
    [self.contentView addConstraints:self.cellViewConstraints];
  }
}

#pragma mark Factory Methods

-(UILabel *)newConnectionNameLabel{
  UILabel *title = [[UILabel alloc] init];
  [title setTextAlignment:NSTextAlignmentLeft];
  [title setBackgroundColor:[UIColor clearColor]];
  [title setFont:[QIFontProvider fontWithSize:10.0f style:Bold]];
  [title setAdjustsFontSizeToFitWidth:YES];
  [title setTextColor:[UIColor colorWithWhite:0.33f alpha:1.0f]];
  [title setTranslatesAutoresizingMaskIntoConstraints:NO];
  return title;
}

-(UILabel *)newKnowledgeIndexLabel{
  UILabel *label= [[UILabel alloc] init];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:10.0f style:Bold]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextColor:[UIColor colorWithWhite:0.5f alpha:1.0f]];
  [label setTextAlignment:NSTextAlignmentCenter]; 
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

- (AsyncImageView *)newProfileImageView{
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView.layer setCornerRadius:4.0f];
  [profileImageView setClipsToBounds:YES];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [profileImageView setContentMode:UIViewContentModeScaleAspectFit];
  [profileImageView setShowActivityIndicator:YES];
  [profileImageView setCrossfadeDuration:0.3f];
  [profileImageView setCrossfadeImages:YES];
  return profileImageView;
}

- (UIImageView *)newTrendImage{
  UIImageView *imageView = [[UIImageView alloc] init];
  [imageView setContentMode:UIViewContentModeScaleAspectFit];   
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imageView;
}

- (UIView *)newKeyKnownView{
  UIView *view = [[UIView alloc] init];
  [view setBackgroundColor:[UIColor colorWithRed:1.0f green:.71f blue:.20f alpha:1.0f]];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  return view;
}

       
@end
