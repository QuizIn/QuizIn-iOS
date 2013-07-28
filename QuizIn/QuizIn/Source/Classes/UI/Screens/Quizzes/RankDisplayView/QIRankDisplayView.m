#import "QIRankDisplayView.h"
#import "QIFontProvider.h"
#import "QIRankDefinition.h"

@interface QIRankDisplayView ()

@property(nonatomic, strong) UILabel *rankDescriptionLabel;
@property(nonatomic, strong,) UIImageView *backgroundImage;
@property(nonatomic, strong,) UIImageView *rankBadgeImage;
@property(nonatomic, strong) NSMutableArray *rankDisplayViewConstraints;

@end

@implementation QIRankDisplayView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _backgroundImage = [self newBackgroundImage];
    _rankDescriptionLabel = [self newRankDescriptionLabel];
    _rankBadgeImage = [self newRankBadgeImage];
    _rankShareButton = [self newRankShareButton];
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

#pragma mark Data Update

- (void) updateRankBadgeImage{
  self.rankBadgeImage.image = [QIRankDefinition getRankBadgeForRank:self.rank];
}

-(void) updateRankDescription{
  self.rankDescriptionLabel.text = [QIRankDefinition getRankDescriptionForRank:self.rank];
}

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self addSubview:self.backgroundImage];
  [self addSubview:self.rankDescriptionLabel];
  [self addSubview:self.rankBadgeImage];
  [self addSubview:self.rankShareButton];
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.rankDisplayViewConstraints) {
    
    self.rankDisplayViewConstraints = [NSMutableArray array];
    //Constrain Background Image
    NSDictionary *rankViews = NSDictionaryOfVariableBindings(_backgroundImage,_rankBadgeImage,_rankDescriptionLabel,_rankShareButton);
    
    NSArray *hBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *vBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    
    [self.rankDisplayViewConstraints addObjectsFromArray:hBackground];
    [self.rankDisplayViewConstraints addObjectsFromArray:vBackground];
    
    NSArray *hRankElements =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_rankBadgeImage(==50)][_rankDescriptionLabel][_rankShareButton(==30)]|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *vRankBadge =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rankBadgeImage]|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    
    NSArray *vRankLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rankDescriptionLabel]|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    NSArray *vRankShare =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rankShareButton]|"
                                            options:0
                                            metrics:nil
                                              views:rankViews];
    
    [self.rankDisplayViewConstraints addObjectsFromArray:hBackground];
    [self.rankDisplayViewConstraints addObjectsFromArray:vBackground];
    [self.rankDisplayViewConstraints addObjectsFromArray:hRankElements];
    [self.rankDisplayViewConstraints addObjectsFromArray:vRankBadge];
    [self.rankDisplayViewConstraints addObjectsFromArray:vRankLabel];
    [self.rankDisplayViewConstraints addObjectsFromArray:vRankShare];
    
    [self addConstraints:self.rankDisplayViewConstraints];
  }
}

#pragma mark Factory Methods

-(UIImageView *)newBackgroundImage{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_headerbar"]];
  [imageView setAlpha:0.65f];
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

- (UILabel *)newRankDescriptionLabel {
  UILabel *resultLabel = [[UILabel alloc] init];
  [resultLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  [resultLabel setBackgroundColor:[UIColor clearColor]];
  [resultLabel setFont:[QIFontProvider fontWithSize:12.0f style:Regular]];
  [resultLabel setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
  [resultLabel setAdjustsFontSizeToFitWidth:YES];
  [resultLabel setNumberOfLines:3];
  return resultLabel;
}

- (UIButton *)newRankShareButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[UIImage imageNamed:@"quizin_information_btn"] forState:UIControlStateNormal];
  [button setContentMode:UIViewContentModeScaleAspectFill];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

@end