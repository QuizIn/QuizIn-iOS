#import "QIQuizFinishView.h"
#import "QIFontProvider.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface QIQuizFinishView ()
@property (nonatomic,strong) UIImageView *viewBackground;
@property (nonatomic,strong) UIImageView *cardImage;
@property (nonatomic,strong) UIImageView *profileImageView;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *result;
@property (nonatomic,strong) UILabel *tagline;

@property (nonatomic,strong) NSMutableArray *viewConstraints; 

@end

@implementation QIQuizFinishView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewBackground = [self newViewBackground];
      _cardImage = [self newCardImage];
      _profileImageView = [self newProfileImageView];
      _title = [self newTitleLabel];
      _result = [self newResultLabel];
      _tagline = [self newTaglineLabel];
      _doneButton = [self newDoneButton];
      _goAgainButton = [self newGoAgainButton];
      _correctAnswers = 1;
      _totalQuestions = 1;
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.cardImage];
  [self addSubview:self.profileImageView];
  [self addSubview:self.title];
  [self addSubview:self.result];
  [self addSubview:self.tagline];
  [self addSubview:self.doneButton];
  [self addSubview:self.goAgainButton];
}

#pragma mark Properties
- (void)setCorrectAnswers:(NSInteger)correctAnswers{
  _correctAnswers = correctAnswers;
  [self updateResult]; 
}

- (void)setTotalQuestions:(NSInteger)totalQuestions{
  _totalQuestions = totalQuestions;
  [self updateResult]; 
}

- (void)setProfileImageURL:(NSURL *)profileImageURL{
  _profileImageURL = profileImageURL;
  [self updateProfileImageView];
}

#pragma mark Data Layout
- (void)updateResult{
  self.result.text = [NSString stringWithFormat:@"%d/%d",self.correctAnswers,self.totalQuestions];
  if (self.totalQuestions > 0){
    float percent = (float)self.correctAnswers/(float)self.totalQuestions;
    NSString *taglineText = @"Well Done!";
    if (percent >= 0.0f && percent <=.3f) {
      taglineText = @"Horrible";
    }
    else if (percent > .3f && percent <=.6f){
      taglineText = @"Mediocre";
    }
    else if (percent > .6f && percent <=.8f){
      taglineText = @"Get'n There";
    }
    else if (percent > .8f && percent <1.0f){
      taglineText = @"Well Done";
    }
    else if (percent == 1.0f){
      taglineText = @"Flawless";
    }
    self.tagline.text = taglineText;
  }
}

- (void)updateProfileImageView{
  [self.profileImageView setImageURL:self.profileImageURL];
}

#pragma mark Layout
- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.viewConstraints) {
    
    self.viewConstraints = [NSMutableArray array];
    //Constrain Background Image
    NSDictionary *finishViews = NSDictionaryOfVariableBindings(_viewBackground, _cardImage, _profileImageView, _title, _result, _tagline, _doneButton, _goAgainButton);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:finishViews];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:finishViews];
    
    [self.viewConstraints addObjectsFromArray:hBackgroundContraints];
    [self.viewConstraints addObjectsFromArray:vBackgroundContraints];

    
    NSArray *hLockedLabelStatus =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_title]|"
                                            options:0
                                            metrics:nil
                                              views:finishViews];
    NSArray *hBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-28-[_cardImage(==263)]-29-|"
                                            options:0
                                            metrics:nil
                                              views:finishViews];

    NSArray *hShareButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-78-[_doneButton(==78)]-7-[_goAgainButton(==78)]"
                                            options:NSLayoutFormatAlignAllBottom
                                            metrics:nil
                                              views:finishViews];
    NSArray *vAll =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_title(==30)]-30-[_cardImage]-30-[_doneButton(==22)]"
                                            options:0
                                            metrics:nil
                                              views:finishViews];
    
    NSArray *hProfileImage =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-47-[_profileImageView(==80)]-20-[_result]"
                                            options:0
                                            metrics:nil
                                              views:finishViews];
    
    NSArray *vProfileImage =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-129-[_profileImageView(==80)]-(-65)-[_result(==50)]"
                                            options:0
                                            metrics:nil
                                              views:finishViews];
    
    NSArray *hRankLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagline]|"
                                            options:0
                                            metrics:nil
                                              views:finishViews];
    NSArray *vRankLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_cardImage]-(-25)-[_tagline(==25)]"
                                            options:0
                                            metrics:nil
                                              views:finishViews];
    
    [self.viewConstraints addObjectsFromArray:hShareButton];
    [self.viewConstraints addObjectsFromArray:hBackground];
    [self.viewConstraints addObjectsFromArray:vAll];
    [self.viewConstraints addObjectsFromArray:hLockedLabelStatus];
    [self.viewConstraints addObjectsFromArray:hProfileImage];
    [self.viewConstraints addObjectsFromArray:vProfileImage];
    [self.viewConstraints addObjectsFromArray:vRankLabel];
    [self.viewConstraints addObjectsFromArray:hRankLabel];
    
    [self addConstraints:self.viewConstraints];
  }
}


#pragma mark Factory Methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

-(UIImageView *)newCardImage{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hobnob_ranking_popup_card"]];
  [imageView setContentMode:UIViewContentModeScaleToFill];
  [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imageView;
}

- (AsyncImageView *)newProfileImageView {
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


- (UILabel *)newTitleLabel {
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:20.0f style:Bold]];
  [label setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setText:@"Quiz Finished"];
  return label;
}

- (UILabel *)newResultLabel {
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:40.0f style:Bold]];
  [label setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setText:@"8/10"];
  return label;
}

- (UILabel *)newTaglineLabel {
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:14.0f style:Bold]];
  [label setTextColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setText:@"Flawless!"];
  return label;
}

- (UIButton *)newGoAgainButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"hobnob_goagain_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

- (UIButton *)newDoneButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"hobnob_done_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

@end
