
#import "QIStatsSummaryView.h"
@interface QIStatsSummaryView ()
@property (nonatomic, strong) NSMutableArray *viewConstraints; 
@end

@implementation QIStatsSummaryView
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _sorterSegmentedControl = [self newSorter];
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.sorterSegmentedControl];
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(_sorterSegmentedControl);
  
  NSArray *hViewConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-5-[_sorterSegmentedControl]-5-|"
                                          options:NSLayoutFormatAlignAllTop
                                          metrics:nil
                                            views:views];
  NSArray *vViewConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:[_sorterSegmentedControl(==30)]-5-|"
                                          options:0
                                          metrics:nil
                                            views:views];
  
  self.viewConstraints = [NSMutableArray array];
  [self.viewConstraints addObjectsFromArray:hViewConstraints];
  [self.viewConstraints addObjectsFromArray:vViewConstraints];
  [self addConstraints:self.viewConstraints]; 
}

#pragma mark Factory Methods
- (UISegmentedControl *)newSorter{
  UISegmentedControl *sorter = [[UISegmentedControl alloc] initWithItems:@[@"First Name",@"Last Name",@"Index"]];
  [sorter setSelectedSegmentIndex:1];
  [sorter setSegmentedControlStyle:UISegmentedControlStyleBar];
  [sorter setTintColor:[UIColor lightGrayColor]];
  [sorter setTranslatesAutoresizingMaskIntoConstraints:NO];
  return sorter;
}

@end
