
#import "QICalendarCellView.h"
#import "QIFontProvider.h"
#import "AsyncImageView.h"

#define TAG_OFFSET 10

@interface QICalendarCellView ()
@property (nonatomic,strong) NSMutableArray *backViewConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewSelfConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewConstraints;
@property (nonatomic,strong) NSMutableArray *imageViewConstraints;
@property (nonatomic,strong) UIImageView *meetingTabImage;
@property (nonatomic,strong) UIView *imagesView;

@end

@implementation QICalendarCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _frontView = [self newFrontView];
      _backView = [self newBackView];
      _meetingTabImage = [self newMeetingTabImage];
      _meetingTime = [self newMeetingTime];
      _meetingTitle = [self newMeetingTitle];
      _meetingLocation = [self newMeetingLocation];
      _imagesView = [self newImagesView];
      
      //CLEANUP
      _imageURLs = @[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                                                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                                                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"],
                                                  [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/080/035/28eea75.jpg"]];
      
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

- (void)setMeetingTitle:(UILabel *)meetingTitle{
  _meetingTitle = meetingTitle;
}

- (void)setMeetingLocation:(UILabel *)meetingLocation{
  _meetingLocation = meetingLocation;
}

- (void)setMeetingTime:(UILabel *)meetingTime{
  _meetingTime = meetingTime;
}

- (void)setImageURLs:(NSArray *)imageURLs{
  if ([imageURLs isEqualToArray:_imageURLs]) {
    return;
  }
  _imageURLs = [imageURLs copy];
  [self updateImages];
}


#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self updateImages];
  [self.frontView addSubview:self.meetingTabImage];
  [self.frontView addSubview:self.meetingTime];
  [self.frontView addSubview:self.meetingTitle];
  [self.frontView addSubview:self.meetingLocation];
  [self.frontView addSubview:self.imagesView];
  [self.backView addSubview:self.frontView];
  [self.contentView addSubview:self.backView];
  [self setNeedsUpdateConstraints];
  
}

-(void)updateImages{
  int tag = TAG_OFFSET;
  for (NSURL *imageURL in self.imageURLs){
    AsyncImageView *profileImageView = [self newProfileImageView:imageURL];
    profileImageView.tag = tag;
    tag++;
    [self.imagesView addSubview:profileImageView];
  }
}
#pragma Data Display

#pragma mark Layout

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
    NSDictionary *cellBackgroundViews = NSDictionaryOfVariableBindings(_meetingTabImage,_meetingLocation,_meetingTitle,_imagesView,_meetingTime);
    
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
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_meetingTime(==50)]"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vMeetingTimeConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_meetingTime]-30-|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vItemsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_meetingTitle(==15)][_meetingLocation(==15)]-(>=0)-[_imagesView(==40)]-4-|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[_meetingTitle]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *hLocationConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[_meetingLocation]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *hImagesViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-65-[_imagesView]-20-|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    
    self.frontViewConstraints = [NSMutableArray array];
    [self.frontViewConstraints addObjectsFromArray:vMeetingTimeConstraints];
    [self.frontViewConstraints addObjectsFromArray:hMeetingTimeConstraints];
    [self.frontViewConstraints addObjectsFromArray:vItemsConstraints];
    [self.frontViewConstraints addObjectsFromArray:hTitleConstraints];
    [self.frontViewConstraints addObjectsFromArray:hLocationConstraints];
    [self.frontViewConstraints addObjectsFromArray:hImagesViewConstraints];
    [self.frontViewConstraints addObjectsFromArray:hBackgroundConstraints];
    [self.frontViewConstraints addObjectsFromArray:vBackgroundConstraints];
    
    //Constrain Profile Image View
    self.imageViewConstraints = [NSMutableArray array];
    for (int tag = TAG_OFFSET; (tag-TAG_OFFSET) < [self.imageURLs count]; tag++){
      UIView *tempView = [self.imagesView viewWithTag:tag];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
      [self.imageViewConstraints addObject:[NSLayoutConstraint constraintWithItem:tempView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imagesView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:(tag-TAG_OFFSET)*50]];
    }
    [self.imagesView addConstraints:self.imageViewConstraints];
    [self.frontView addConstraints:self.frontViewConstraints];
  }
}

#pragma Factory Methods

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

-(UILabel *)newMeetingTime{
  UILabel *time = [[UILabel alloc] init];
  time.textAlignment = NSTextAlignmentCenter;
  time.backgroundColor = [UIColor clearColor];
  time.font = [QIFontProvider fontWithSize:10.0f style:Bold];
  time.adjustsFontSizeToFitWidth = YES;
  time.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [time setTranslatesAutoresizingMaskIntoConstraints:NO];
  time.text = @"4:00pm";
  return time;
}

-(UILabel *)newMeetingTitle{
  UILabel *title = [[UILabel alloc] init];
  title.textAlignment = NSTextAlignmentLeft;
  title.backgroundColor = [UIColor clearColor];
  title.font = [QIFontProvider fontWithSize:10.0f style:Bold];
  title.adjustsFontSizeToFitWidth = YES;
  title.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [title setTranslatesAutoresizingMaskIntoConstraints:NO];
  title.text = @"Meeting Title - Something Good";
  return title;
}

-(UILabel *)newMeetingLocation{
  UILabel *location = [[UILabel alloc] init];
  location.textAlignment = NSTextAlignmentLeft;
  location.backgroundColor = [UIColor clearColor];
  location.font = [QIFontProvider fontWithSize:10.0f style:Regular];
  location.adjustsFontSizeToFitWidth = YES;
  location.textColor = [UIColor colorWithWhite:0.66f alpha:1.0f];
  [location setTranslatesAutoresizingMaskIntoConstraints:NO];
  location.text = @"Meeting Location - Conference Room";
  return location;
}

-(UIView *)newImagesView{
  UIView *imagesView = [[UIView alloc] init];
  [imagesView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return imagesView;
}

- (AsyncImageView *)newProfileImageView:(NSURL *)imageURL {
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  [profileImageView setImageURL:imageURL];
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  return profileImageView;
}

       
@end
