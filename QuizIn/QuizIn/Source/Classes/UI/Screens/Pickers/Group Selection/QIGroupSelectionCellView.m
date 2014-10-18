
#import "QIGroupSelectionCellView.h"
#import "QIFontProvider.h"
#import "UIImageView+QIAFNetworking.h"
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
      _selectionTitleLabel = [self newSelectionTitleLabel];
      _checkMarkImage = [self newCheckMarkImage];
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

#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self.frontView addSubview:self.selectionTabImage];
  [self.frontView addSubview:self.selectionTitleLabel];
  [self.backView addSubview:self.checkMarkImage];
  [self.backView addSubview:self.frontView];
  [self.contentView addSubview:self.backView];
  [self setNeedsUpdateConstraints];
  
}

#pragma Data Display

-(void)updateSelectionTitle{
  self.selectionTitleLabel.text = self.selectionTitle;
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
    NSDictionary *cellBackgroundViews = NSDictionaryOfVariableBindings(_selectionTabImage,_selectionTitleLabel);
    
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
    
    NSArray *vItemsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_selectionTitleLabel]-10-|"
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:cellBackgroundViews];
  
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[_selectionTitleLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellBackgroundViews];

    self.frontViewConstraints = [NSMutableArray array];
    [self.frontViewConstraints addObjectsFromArray:hBackgroundConstraints];
    [self.frontViewConstraints addObjectsFromArray:vBackgroundConstraints];
    [self.frontViewConstraints addObjectsFromArray:vItemsConstraints];
    [self.frontViewConstraints addObjectsFromArray:hTitleConstraints];
    [self.frontView addConstraints:self.frontViewConstraints];
    
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
  UIImageView *tab = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"calendar_meetingtab_small"] resizableImageWithCapInsets:UIEdgeInsetsMake(20,55, 20, 19) ]];
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

-(UILabel *)newSelectionTitleLabel{
  UILabel *title = [[UILabel alloc] init];
  title.textAlignment = NSTextAlignmentLeft;
  title.backgroundColor = [UIColor clearColor];
  title.font = [QIFontProvider fontWithSize:13.0f style:Bold];
  title.adjustsFontSizeToFitWidth = YES;
  title.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [title setTranslatesAutoresizingMaskIntoConstraints:NO];
  return title;
}
       
@end
