
#import "QICalendarCellView.h"
#import "QIFontProvider.h"
#import "UIImageView+QIAFNetworking.h"
#import <QuartzCore/QuartzCore.h>

#define TAG_OFFSET 10

@interface QICalendarCellView ()
@property (nonatomic,strong) NSMutableArray *backViewConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewSelfConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewConstraints;
@property (nonatomic,strong) NSMutableArray *imageViewConstraints;
@property (nonatomic,strong) UIImageView *meetingTabImage;
@property (nonatomic,strong) UILabel *meetingTitleLabel;
@property (nonatomic,strong) UILabel *meetingLocationLabel;
@property (nonatomic,strong) UILabel *meetingTimeLabel;
@property (nonatomic,strong) UILabel *morePeopleLabel;
@property (nonatomic,strong) UIView *imagesView;
@property (nonatomic,assign) NSInteger numberOfImages;

@end

@implementation QICalendarCellView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _frontView = [self newFrontView];
      _backView = [self newBackView];
      _meetingTabImage = [self newMeetingTabImage];
      _meetingTimeLabel = [self newMeetingTimeLabel];
      _meetingTitleLabel = [self newMeetingTitleLabel];
      _meetingLocationLabel = [self newMeetingLocationLabel];
      _morePeopleLabel = [self newMorePeopleLabel];
      _imagesView = [self newImagesView];
      _numberOfImages = 0;
      [self constructViewHierarchy];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma properties

- (void)setBackView:(UIView *)backView{
  _backView = backView;
}

- (void)setFrontView:(UIView *)frontView{
  _frontView = frontView;
}

- (void)setMeetingTitle:(NSString *)meetingTitle{
  _meetingTitle = meetingTitle;
  [self updateMeetingTitle];
}

- (void)setMeetingLocation:(NSString *)meetingLocation{
  _meetingLocation = meetingLocation;
  [self updateMeetingLocation];
}

- (void)setMeetingTime:(NSString *)meetingTime{
  _meetingTime = meetingTime;
  [self updateMeetingTime];
}

- (void)setImageURLs:(NSArray *)imageURLs{
  if ([imageURLs isEqualToArray:_imageURLs]) {
    return;
  }
  _imageURLs = [imageURLs copy];
  [self updateImages];
  [self updateMorePeopleLabel];
}


#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self updateImages];
  [self.frontView addSubview:self.meetingTabImage];
  [self.frontView addSubview:self.meetingTimeLabel];
  [self.frontView addSubview:self.meetingTitleLabel];
  [self.frontView addSubview:self.meetingLocationLabel];
  [self.frontView addSubview:self.imagesView];
  [self.frontView addSubview:self.morePeopleLabel];
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

-(void)updateMeetingTitle{
  self.meetingTitleLabel.text = self.meetingTitle;
}

-(void)updateMeetingLocation{
  self.meetingLocationLabel.text = self.meetingLocation;
}

-(void)updateMeetingTime{
  self.meetingTimeLabel.text = self.meetingTime;
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
    NSDictionary *cellFrontViews = NSDictionaryOfVariableBindings(_frontView);
    
    NSArray *hFrontViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_frontView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:cellFrontViews];
    NSArray *vFrontViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_frontView]|"
                                            options:0
                                            metrics:nil
                                              views:cellFrontViews];
    
    self.frontViewSelfConstraints = [NSMutableArray array];
    [self.frontViewSelfConstraints addObjectsFromArray:hFrontViewConstraints];
    [self.frontViewSelfConstraints addObjectsFromArray:vFrontViewContraints];
    
    [self.backView addConstraints:self.frontViewSelfConstraints];
    
    //Constrain FrontView
    NSDictionary *cellBackgroundViews = NSDictionaryOfVariableBindings(_meetingTabImage,_meetingLocationLabel,_meetingTitleLabel,_imagesView,_meetingTimeLabel,_morePeopleLabel);
    
    NSArray *hBackgroundConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_meetingTabImage]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vBackgroundConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_meetingTabImage]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *hMeetingTimeConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-4-[_meetingTimeLabel(==44)]"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vMeetingTimeConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_meetingTimeLabel]-30-|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vItemsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_meetingTitleLabel(==12)][_meetingLocationLabel(==12)]-(>=0)-[_imagesView(==38)]-8-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:cellBackgroundViews];
  
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-70-[_meetingTitleLabel]|"
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
    [self.frontViewConstraints addObjectsFromArray:hMeetingTimeConstraints];
    [self.frontViewConstraints addObjectsFromArray:vMeetingTimeConstraints];
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

-(UIImageView *)newMeetingTabImage{
  UIImageView *tab = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"calendar_meetingtab"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,55, 20, 19) ]];
  [tab setContentMode:UIViewContentModeScaleToFill];
  [tab setTranslatesAutoresizingMaskIntoConstraints:NO];
  return tab;
}

-(UILabel *)newMeetingTimeLabel{
  UILabel *time = [[UILabel alloc] init];
  time.textAlignment = NSTextAlignmentLeft;
  time.backgroundColor = [UIColor clearColor];
  time.font = [QIFontProvider fontWithSize:10.0f style:Bold];
  time.adjustsFontSizeToFitWidth = YES;
  time.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [time setTranslatesAutoresizingMaskIntoConstraints:NO];
  return time;
}

-(UILabel *)newMeetingTitleLabel{
  UILabel *title = [[UILabel alloc] init];
  title.textAlignment = NSTextAlignmentLeft;
  title.backgroundColor = [UIColor clearColor];
  title.font = [QIFontProvider fontWithSize:10.0f style:Bold];
  title.adjustsFontSizeToFitWidth = YES;
  title.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [title setTranslatesAutoresizingMaskIntoConstraints:NO];
  return title;
}

-(UILabel *)newMeetingLocationLabel{
  UILabel *location = [[UILabel alloc] init];
  location.textAlignment = NSTextAlignmentLeft;
  location.backgroundColor = [UIColor clearColor];
  location.font = [QIFontProvider fontWithSize:10.0f style:Regular];
  location.adjustsFontSizeToFitWidth = YES;
  location.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
  [location setTranslatesAutoresizingMaskIntoConstraints:NO];
  return location;
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

- (UIImageView *)newProfileImageView:(NSURL *)imageURL {
  UIImageView *profileImageView = [[UIImageView alloc] init];
  profileImageView.layer.cornerRadius = 4.0f;
  profileImageView.clipsToBounds = YES;
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  
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
       
@end
