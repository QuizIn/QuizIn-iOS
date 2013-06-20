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
@property (nonatomic,strong) NSMutableArray *frontViewConstraints;

@end

@implementation QICalendarCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _frontView = [self newFrontView];
      _backView = [self newBackView];
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
    
    self.frontViewConstraints = [NSMutableArray array];
    [self.frontViewConstraints addObjectsFromArray:hFrontViewConstraints];
    [self.frontViewConstraints addObjectsFromArray:vFrontViewContraints];
    
    [self.backView addConstraints:self.frontViewConstraints];
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
@end
