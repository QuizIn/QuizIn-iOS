
#import "QIStatsSectionHeaderView.h"
#import "QIFontProvider.h"

@interface QIStatsSectionHeaderView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) UILabel *sectionTitleLabel;

@property (nonatomic, strong) NSMutableArray *constraints; 

@end


@implementation QIStatsSectionHeaderView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewBackground = [self newViewBackground]; 
      _sectionTitleLabel = [self newTitleLabel];
      _alphaHeader = [self newHeaderImageWithIndex:0];
      _correctHeader = [self newHeaderImageWithIndex:1];
      _incorrectHeader = [self newHeaderImageWithIndex:2];
      _trendHeader = [self newHeaderImageWithIndex:3];
      _knownHeader = [self newHeaderImageWithIndex:4];
      
      [self constructViewHierarchy]; 
    }
    return self;
}
#pragma mark Properties
- (void)setSectionTitle:(NSString *)sectionTitle{
  _sectionTitle = sectionTitle;
  [self updateSectionTitleLabel];
}

- (void)setSelectedSorter:(NSInteger)selectedSorter{
  _selectedSorter = selectedSorter;
  [self updateSelectedSorter]; 
}
#pragma mark Data Layout
- (void)updateSectionTitleLabel{
  self.sectionTitleLabel.text = self.sectionTitle; 
}

- (void)updateSelectedSorter{
  NSArray *buttons = [NSArray arrayWithObjects:
                      self.alphaHeader,
                      self.correctHeader,
                      self.incorrectHeader,
                      self.trendHeader,
                      self.knownHeader,
                      nil];
  for (UIButton *button in buttons){
    if (self.selectedSorter == button.tag)
      [button setSelected:YES];
    else
      [button setSelected:NO]; 
  }
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground]; 
  [self addSubview:self.sectionTitleLabel];
  [self addSubview:self.alphaHeader]; 
  [self addSubview:self.correctHeader];
  [self addSubview:self.incorrectHeader];
  [self addSubview:self.trendHeader];
  [self addSubview:self.knownHeader];
}

#pragma mark Constraints
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraints){
    self.constraints = [NSMutableArray array];
    
    NSDictionary *headerViews = NSDictionaryOfVariableBindings(_sectionTitleLabel,_viewBackground, _alphaHeader, _correctHeader, _incorrectHeader, _trendHeader, _knownHeader);
  
    //Place Sign
    NSArray *hBackgroundConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *vBackgroundConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *hTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_sectionTitleLabel][_alphaHeader]"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *vTitleConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_sectionTitleLabel]|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *hHeaderConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_alphaHeader(==30)][_correctHeader(==_alphaHeader)][_incorrectHeader(==_alphaHeader)][_trendHeader(==_alphaHeader)][_knownHeader(==_alphaHeader)]-10-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:headerViews];
    NSArray *vAlphaConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_alphaHeader]-10-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *vCorrectConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_correctHeader]-10-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *vIncorrectConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_incorrectHeader]-10-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *vKnownConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_trendHeader]-10-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    NSArray *vTrendConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_knownHeader]-10-|"
                                            options:0
                                            metrics:nil
                                              views:headerViews];
    
    [self.constraints addObjectsFromArray:hBackgroundConstraints];
    [self.constraints addObjectsFromArray:vBackgroundConstraints];
    [self.constraints addObjectsFromArray:hTitleConstraints];
    [self.constraints addObjectsFromArray:vTitleConstraints];
    [self.constraints addObjectsFromArray:hHeaderConstraints];
    [self.constraints addObjectsFromArray:vAlphaConstraints];
    [self.constraints addObjectsFromArray:vCorrectConstraints];
    [self.constraints addObjectsFromArray:vIncorrectConstraints];
    [self.constraints addObjectsFromArray:vTrendConstraints];
    [self.constraints addObjectsFromArray:vKnownConstraints];
    
    [self addConstraints:self.constraints]; 

  }
}

- (UILabel *)newTitleLabel {
  UILabel *label = [[UILabel alloc] init];
  label.textAlignment = NSTextAlignmentLeft;
  label.backgroundColor = [UIColor clearColor];
  label.font = [QIFontProvider fontWithSize:15.0f style:Bold];
  label.adjustsFontSizeToFitWidth = YES;
  label.textColor = [UIColor colorWithWhite:0.50f alpha:1.0f];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

- (UIImageView *)newViewBackground{
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_stattextbar"]];
  [image setBackgroundColor:[UIColor clearColor]];
  [image setAlpha:.8f];
  [image setTranslatesAutoresizingMaskIntoConstraints:NO];
  return image;
}

- (UIButton *)newHeaderImageWithIndex:(NSInteger)index{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  switch (index) {
    case 0:
      [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_lock_btn"] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateSelected];
      break;
    case 1:
      [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_lock_btn"] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateSelected];
      break;
    case 2:
      [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_lock_btn"] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateSelected];
      break;
    case 3:
      [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_lock_btn"] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateSelected];
      break;
    case 4:
      [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_lock_btn"] forState:UIControlStateNormal];
      [button setBackgroundImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateSelected];
      break;
    default:
      break;
  }
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setBackgroundColor:[UIColor clearColor]];
  [button setTag:index];
  return button;
}

@end
