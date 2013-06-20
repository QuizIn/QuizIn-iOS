//
//  QICalendarCellView.m
//  QuizIn
//
//  Created by Rick Kuhlman on 6/16/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import "QICalendarCellView.h"

@interface QICalendarCellView ()
@property (nonatomic,strong) NSMutableArray *backViewConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewSelfConstraints;
@property (nonatomic,strong) NSMutableArray *frontViewConstraints;
@property (nonatomic,strong) UIImageView *meetingTabImage;

@end

@implementation QICalendarCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _frontView = [self newFrontView];
      _backView = [self newBackView];
      _meetingTabImage = [self newMeetingTabImage];
      [self constructViewHierarchy];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma properties

#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self.frontView addSubview:self.meetingTabImage];
  [self.backView addSubview:self.frontView];
  [self.contentView addSubview:self.backView];
  [self setNeedsUpdateConstraints];
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
    NSDictionary *cellBackgroundViews = NSDictionaryOfVariableBindings(_meetingTabImage);
    
    NSArray *hBackgroundConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_meetingTabImage]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:cellBackgroundViews];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_meetingTabImage]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];
    
    self.frontViewConstraints = [NSMutableArray array];
    [self.frontViewConstraints addObjectsFromArray:hBackgroundConstraints];
    [self.frontViewConstraints addObjectsFromArray:vBackgroundContraints];
    
    [self.frontView addConstraints:self.frontViewConstraints];
  }
}


#pragma Factory Methods

-(UIView *)newFrontView{
  UIView *frontView = [[UIView alloc] init];
  [frontView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [frontView setBackgroundColor:[UIColor redColor]];
  return frontView;
}

-(UIView *)newBackView{
  UIView *frontView = [[UIView alloc] init];
  [frontView setBackgroundColor:[UIColor blueColor]];
  [frontView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return frontView;
}

-(UIImageView *)newMeetingTabImage{
  UIImageView *tab = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"calendar_meetingtab"] resizableImageWithCapInsets:UIEdgeInsetsMake(5,55, 5, 19) ]];
  [tab setContentMode:UIViewContentModeScaleToFill];
  [tab setTranslatesAutoresizingMaskIntoConstraints:NO];
  return tab;
}
@end
