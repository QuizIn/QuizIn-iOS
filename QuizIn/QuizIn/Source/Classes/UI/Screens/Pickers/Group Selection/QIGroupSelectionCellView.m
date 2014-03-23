
#import "QIGroupSelectionCellView.h"
#import "QIFontProvider.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_OFFSET 10

@interface QIGroupSelectionCellView ()
@property (nonatomic,strong) NSMutableArray *backViewConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewSelfConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewConstraints;
@property (nonatomic,strong) NSMutableArray *imageViewConstraints;
@property (nonatomic,strong) UIImageView *selectionTabImage;
@property (nonatomic,strong) UIImageView *checkMarkImage;
@property (nonatomic,strong) UILabel *selectionTitleLabel;
@property (nonatomic,strong) UILabel *selectionSubtitleLabel;
@property (nonatomic,strong) UILabel *numberOfContactsLabel;
@property (nonatomic,strong) UILabel *morePeopleLabel;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) UIView *imagesView;
@property (nonatomic,assign) NSInteger numberOfImages;
@property (nonatomic,strong) NSLayoutConstraint *offsetConstraint;


@end

@implementation QIGroupSelectionCellView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _frontView = [self newFrontView];
      _backView = [self newBackView];
      _selectionTabImage = [self newSelectionTabImage];
      _numberOfContactsLabel = [self newNumberOfContactsLabel];
      _selectionTitleLabel = [self newSelectionTitleLabel];
      _selectionSubtitleLabel = [self newSelectionSubtitleLabel];
      _morePeopleLabel = [self newMorePeopleLabel];
      _imagesView = [self newImagesView];
      _numberOfImages = 0;
      _logoImageView = [self newLogoImageView];
      _checkMarkImage = [self newCheckMarkImage];
      //_slideOffset = [NSLayoutConstraint constraintWithItem:_frontView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0];
      [self constructViewHierarchy];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma properties

-(void)setSlideOffset:(NSInteger)slideOffset{
  _slideOffset = slideOffset;
  [_offsetConstraint setConstant:_slideOffset];
  [self layoutIfNeeded];
}


- (void)setBackView:(UIView *)backView{
  _backView = backView;
}

- (void)setFrontView:(UIView *)frontView{
  _frontView = frontView;
}

- (void)setSelectionTitle:(NSString *)selectionTitle{
  _selectionTitle = selectionTitle;
  [self updateSelectionTitle];
}

- (void)setSelectionSubtitle:(NSString *)selectionSubtitle{
  _selectionSubtitle = selectionSubtitle;
  [self updateSelectionSubtitle];
}

- (void)setNumberOfContacts:(NSString *)numberOfContacts{
  _numberOfContacts = numberOfContacts;
  [self updateNumberOfContacts];
}

- (void)setImageURLs:(NSArray *)imageURLs{
  if ([imageURLs isEqualToArray:_imageURLs]) {
    return;
  }
  _imageURLs = [imageURLs copy];
  [self updateImages];
  [self updateMorePeopleLabel];
}

- (void)setLogoURL:(NSURL *)logoURL{
  _logoURL = logoURL;
  [self updateLogoImage];
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self updateImages];
  [self.frontView addSubview:self.selectionTabImage];
  [self.frontView addSubview:self.logoImageView];
  [self.frontView addSubview:self.numberOfContactsLabel];
  [self.frontView addSubview:self.selectionTitleLabel];
  [self.frontView addSubview:self.selectionSubtitleLabel];
  [self.frontView addSubview:self.imagesView];
  [self.frontView addSubview:self.morePeopleLabel];
  [self.backView addSubview:self.checkMarkImage];
  [self.backView addSubview:self.frontView];
  [self.contentView addSubview:self.backView];
  [self setNeedsUpdateConstraints];
  
}

-(void)updateImages{
  int tag = TAG_OFFSET;
  self.numberOfImages = [self.imageURLs count];
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfImages)];
  if ([self.imageURLs count]>4){
    indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 4)];
    self.numberOfImages = 4; 
  }
  NSArray *displayedImageURLs = [self.imageURLs objectsAtIndexes:indexSet];
  for (NSURL *imageURL in displayedImageURLs){
    UIImageView *profileImageView = [self newProfileImageView:imageURL];
    profileImageView.tag = tag;
    tag++;
    [self.imagesView addSubview:profileImageView];
  }
}


#pragma Data Display

-(void)updateSelectionTitle{
  self.selectionTitleLabel.text = self.selectionTitle;
}

-(void)updateSelectionSubtitle{
  self.selectionSubtitleLabel.text = self.selectionSubtitle;
}

-(void)updateNumberOfContacts{
  self.numberOfContactsLabel.text = self.numberOfContacts;
}

-(void)updateMorePeopleLabel{
  if ([self.imageURLs count] > 4){
    int more = [self.imageURLs count]-4;
    self.morePeopleLabel.text = [NSString stringWithFormat:@"+%d \nMore",more];
  }
  else{
    self.morePeopleLabel.text = @"";
  }
}

-(void)updateLogoImage{
  // TODO: (Rene) Replace this with AFNetworking async image fetch.
//  if (self.logoURL && ![self.logoURL isKindOfClass:[NSNull class]]) {
//    [self.logoImageView setImageURL:self.logoURL];
//  }
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.backViewConstraints) {
    
    //Constrain BackView
    NSDictionary *cellBackViews = NSDictionaryOfVariableBindings(_backView);
    
    NSArray *hBackViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_backView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:cellBackViews];
    NSArray *vBackViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_backView]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackViews];
    
    self.backViewConstraints = [NSMutableArray array];
    [self.backViewConstraints addObjectsFromArray:hBackViewConstraints];
    [self.backViewConstraints addObjectsFromArray:vBackViewContraints];
    
    [self.contentView addConstraints:self.backViewConstraints];
    
    //Constrain FrontView
    NSLayoutConstraint *frontViewWidthConstraint = [NSLayoutConstraint constraintWithItem:_frontView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0];
    NSLayoutConstraint *frontViewHeightConstraint = [NSLayoutConstraint constraintWithItem:_frontView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0];
    
    _offsetConstraint = [NSLayoutConstraint constraintWithItem:_frontView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:_slideOffset];
    
    NSLayoutConstraint *frontViewTopConstraint = [NSLayoutConstraint constraintWithItem:_frontView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0];
    
    self.frontViewSelfConstraints = [NSMutableArray array];
    
    [self.frontViewSelfConstraints addObject:[NSLayoutConstraint constraintWithItem:_checkMarkImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_frontView attribute:NSLayoutAttributeHeight multiplier:0.4f constant:0.0f]];
    [self.frontViewSelfConstraints addObject:[NSLayoutConstraint constraintWithItem:_checkMarkImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_frontView attribute:NSLayoutAttributeHeight multiplier:0.4f constant:0.0f]];
    [self.frontViewSelfConstraints addObject:[NSLayoutConstraint constraintWithItem:_checkMarkImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_frontView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.frontViewSelfConstraints addObject:[NSLayoutConstraint constraintWithItem:_checkMarkImage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-5.0f]];
    
    [self.frontViewSelfConstraints addObjectsFromArray:@[_offsetConstraint,frontViewWidthConstraint,frontViewHeightConstraint,frontViewTopConstraint]];
    
    [self.backView addConstraints:self.frontViewSelfConstraints];
  
   //Constrain FrontView
    NSDictionary *cellBackgroundViews = NSDictionaryOfVariableBindings(_selectionTabImage,_selectionSubtitleLabel,_selectionTitleLabel,_logoImageView,_imagesView,_numberOfContactsLabel,_morePeopleLabel);
    
    NSArray *hBackgroundConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_selectionTabImage]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vBackgroundConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_selectionTabImage]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *hNumberOfContactsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_numberOfContactsLabel(==44)]"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *hLogoConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_logoImageView(==44)]"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vLeftViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[_logoImageView]-5-[_numberOfContactsLabel]-(>=5)-|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vItemsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_selectionTitleLabel(==12)][_selectionSubtitleLabel(==12)][_imagesView(==38)]"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:cellBackgroundViews];
  
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[_selectionTitleLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *hMorePeopleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imagesView(==173)]-3-[_morePeopleLabel(==30)]"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vMorePeopleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_morePeopleLabel(==20)]"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:cellBackgroundViews];

    
    
    self.frontViewConstraints = [NSMutableArray array];
    [self.frontViewConstraints addObjectsFromArray:hBackgroundConstraints];
    [self.frontViewConstraints addObjectsFromArray:vBackgroundConstraints];
    [self.frontViewConstraints addObjectsFromArray:hNumberOfContactsConstraints];
    [self.frontViewConstraints addObjectsFromArray:hLogoConstraints];
    [self.frontViewConstraints addObjectsFromArray:vLeftViewConstraints];
    [self.frontViewConstraints addObjectsFromArray:vItemsConstraints];
    [self.frontViewConstraints addObjectsFromArray:hTitleConstraints];
    [self.frontViewConstraints addObjectsFromArray:hMorePeopleConstraints];
    [self.frontViewConstraints addObjectsFromArray:vMorePeopleConstraints];
    [self.frontView addConstraints:self.frontViewConstraints];
    
    //Constrain Profile Image View
    self.imageViewConstraints = [NSMutableArray array];
    for (int tag = TAG_OFFSET; (tag-TAG_OFFSET) < self.numberOfImages; tag++){
      UIView *tempView = [self.imagesView viewWithTag:tag];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:(tag-TAG_OFFSET)*45]];
    }

    [self.imagesView addConstraints:self.imageViewConstraints];

  }
}

#pragma mark Factory Methods

-(UIView *)newFrontView{
  UIView *frontView = [[UIView alloc] init];
  [frontView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return frontView;
}

-(UIView *)newBackView{
  UIView *backView = [[UIView alloc] init];
  [backView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return backView;
}

-(UIImageView *)newSelectionTabImage{
  UIImageView *tab = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"calendar_meetingtab"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,55, 20, 19) ]];
  [tab setContentMode:UIViewContentModeScaleToFill];
  [tab setTranslatesAutoresizingMaskIntoConstraints:NO];
  return tab;
}

-(UIImageView *)newCheckMarkImage{
  UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_checkmark"]];
  [check setContentMode:UIViewContentModeScaleAspectFill];
  [check setTranslatesAutoresizingMaskIntoConstraints:NO];
  return check;
}

-(UILabel *)newNumberOfContactsLabel{
  UILabel *contacts = [[UILabel alloc] init];
  contacts.textAlignment = NSTextAlignmentCenter;
  contacts.backgroundColor = [UIColor clearColor];
  contacts.font = [QIFontProvider fontWithSize:12.0f style:Bold];
  contacts.adjustsFontSizeToFitWidth = YES;
  contacts.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [contacts setTranslatesAutoresizingMaskIntoConstraints:NO];
  return contacts;
}

-(UILabel *)newSelectionTitleLabel{
  UILabel *title = [[UILabel alloc] init];
  title.textAlignment = NSTextAlignmentLeft;
  title.backgroundColor = [UIColor clearColor];
  title.font = [QIFontProvider fontWithSize:10.0f style:Bold];
  title.adjustsFontSizeToFitWidth = YES;
  title.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [title setTranslatesAutoresizingMaskIntoConstraints:NO];
  return title;
}

-(UILabel *)newSelectionSubtitleLabel{
  UILabel *subtitle = [[UILabel alloc] init];
  subtitle.textAlignment = NSTextAlignmentLeft;
  subtitle.backgroundColor = [UIColor clearColor];
  subtitle.font = [QIFontProvider fontWithSize:10.0f style:Regular];
  subtitle.adjustsFontSizeToFitWidth = YES;
  subtitle.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
  [subtitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return subtitle;
}

-(UILabel *)newMorePeopleLabel{
  UILabel *more= [[UILabel alloc] init];
  more.textAlignment = NSTextAlignmentLeft;
  more.numberOfLines = 2;
  more.backgroundColor = [UIColor clearColor];
  more.font = [QIFontProvider fontWithSize:7.0f style:Bold];
  more.adjustsFontSizeToFitWidth = YES;
  more.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
  [more setTranslatesAutoresizingMaskIntoConstraints:NO];
  return more;
}

-(UIView *)newImagesView{
  UIView *imagesView = [[UIView alloc] init];
  [imagesView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imagesView;
}

// TODO: (Rene) Replace this with AFNetworking async image fetch.
- (UIImageView *)newProfileImageView:(NSURL *)imageURL {
  UIImageView *profileImageView = [[UIImageView alloc] init];
  profileImageView.layer.cornerRadius = 4.0f;
  profileImageView.clipsToBounds = YES;
//  [profileImageView setImageURL:imageURL];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
//  profileImageView.showActivityIndicator = YES;
//  profileImageView.crossfadeDuration = 0.3f;
//  profileImageView.crossfadeImages = YES;
  return profileImageView;
}

// TODO: (Rene) Replace this with AFNetworking async image fetch.
- (UIImageView *)newLogoImageView {
  UIImageView *logoImageView = [[UIImageView alloc] init];
  logoImageView.layer.cornerRadius = 4.0f;
  logoImageView.clipsToBounds = YES;
  [logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
//  logoImageView.contentMode = UIViewContentModeScaleAspectFit;
//  logoImageView.showActivityIndicator = YES;
//  logoImageView.crossfadeDuration = 0.3f;
//  logoImageView.crossfadeImages = YES;
  return logoImageView;
}
       
@end
