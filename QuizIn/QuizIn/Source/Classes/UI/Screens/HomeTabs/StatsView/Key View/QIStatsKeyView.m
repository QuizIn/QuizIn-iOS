
#import "QIStatsKeyView.h"
#import "QIFontProvider.h"
@interface QIStatsKeyView ()

@property (nonatomic, strong) UIView *keyWellKnown;
@property (nonatomic, strong) UIView *keyMiddle;
@property (nonatomic, strong) UIView *keyNeedsRefresh;
@property (nonatomic, strong) UILabel *labelWellKnown;
@property (nonatomic, strong) UILabel *labelMiddle;
@property (nonatomic, strong) UILabel *labelNeedsRefresh;
@property (nonatomic, strong) NSMutableArray *viewConstraints; 

@end

@implementation QIStatsKeyView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _keyWellKnown = [self newKeyViewWithColorIndex:0];
      _keyMiddle = [self newKeyViewWithColorIndex:1];
      _keyNeedsRefresh = [self newKeyViewWithColorIndex:2];
      _labelWellKnown = [self newKeyLabelWithIndex:0];
      _labelMiddle = [self newKeyLabelWithIndex:1];
      _labelNeedsRefresh = [self newKeyLabelWithIndex:2];
      
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.keyWellKnown];
  [self addSubview:self.keyMiddle];
  [self addSubview:self.keyNeedsRefresh];
  [self addSubview:self.labelWellKnown];
  [self addSubview:self.labelMiddle];
  [self addSubview:self.labelNeedsRefresh];
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  NSDictionary *views = NSDictionaryOfVariableBindings(_keyWellKnown, _keyMiddle, _keyNeedsRefresh, _labelWellKnown, _labelMiddle, _labelNeedsRefresh);
  NSArray *vKeyViews =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_keyWellKnown(==15)][_keyMiddle(==_keyWellKnown)][_keyNeedsRefresh(==_keyWellKnown)]"
                                          options:NSLayoutFormatAlignAllLeft
                                          metrics:nil
                                            views:views];
  NSArray *vLabelViews =
  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_labelWellKnown(==15)][_labelMiddle(==_labelWellKnown)][_labelNeedsRefresh(==_labelWellKnown)]"
                                          options:NSLayoutFormatAlignAllLeft
                                          metrics:nil
                                            views:views];
  NSArray *hWellKnownViews =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_keyWellKnown(==15)]-2-[_labelWellKnown]"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:views];
  NSArray *hMiddleViews =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_keyMiddle(==15)]-2-[_labelMiddle]"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:views];
  
  NSArray *hNeedsRefreshViews =
  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_keyNeedsRefresh(==15)]-2-[_labelNeedsRefresh]"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:views];
  self.viewConstraints = [NSMutableArray array];
  [self.viewConstraints addObjectsFromArray:vKeyViews];
  [self.viewConstraints addObjectsFromArray:vLabelViews];
  [self.viewConstraints addObjectsFromArray:hWellKnownViews];
  [self.viewConstraints addObjectsFromArray:hMiddleViews];
  [self.viewConstraints addObjectsFromArray:hNeedsRefreshViews];
  
  [self addConstraints:self.viewConstraints]; 
}


#pragma mark Strings
- (NSString *) stringWellKnown{
  return @"Well Known";
}

- (NSString *) stringMiddle{
  return @"Sorta Known";
}

- (NSString *) stringNeedsRefresh{
  return @"Needs Refresh";
}

#pragma mark Factory Methods
- (UIView *)newKeyViewWithColorIndex:(NSInteger)index{
  UIView *view = [[UIView alloc] init];
  switch (index) {
    case 0:
      [view setBackgroundColor:[UIColor colorWithRed:1.0f green:.71f blue:.20f alpha:1.0f]];
      break;
    case 1:
      [view setBackgroundColor:[UIColor colorWithRed:.34f green:.45f blue:.64f alpha:1.0f]];
      break;
    case 2:
      [view setBackgroundColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
      break;
    default:
      break;
  }
  [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  return view;
}

- (UILabel *)newKeyLabelWithIndex:(NSInteger)index{
  UILabel *label = [[UILabel alloc] init];
  [label setBackgroundColor:[UIColor clearColor]];
   switch (index) {
     case 0:
       [label setText:[self stringWellKnown]]; 
       break;
     case 1:
       [label setText:[self stringMiddle]];
       break;
     case 2:
       [label setText:[self stringNeedsRefresh]];
       break;
     default:
       break;
   }
  [label setFont:[QIFontProvider fontWithSize:10 style:Regular]];
  [label setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]]; 
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  return label;
}

@end
