
#import "QIStatsSummaryView.h"
@interface QIStatsSummaryView ()
@property (nonatomic, retain) DLPieChart *pieChartView;
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
      _pieChartView = [self newPieChartView]; 
      _sorterSegmentedControl = [self newSorter];
      [self constructViewHierarchy];
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.sorterSegmentedControl];
  [self addSubview:self.pieChartView];
  [self.pieChartView customamizeDraw:self.pieChartView pieCentre:CGPointMake(50, 50) animationSpeed:2.0f labelRadius:30.0f]; 
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  NSDictionary *views = NSDictionaryOfVariableBindings(_sorterSegmentedControl,_pieChartView);
  
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
  
  NSArray *hPieConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"H:[_pieChartView(==140)]|"
                                          options:0
                                          metrics:nil
                                            views:views];
  NSArray *vPieConstraints =
  [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-30-[_pieChartView(==140)]"
                                          options:0
                                          metrics:nil
                                            views:views];
  
  self.viewConstraints = [NSMutableArray array];
  [self.viewConstraints addObjectsFromArray:hViewConstraints];
  [self.viewConstraints addObjectsFromArray:vViewConstraints];
  [self.viewConstraints addObjectsFromArray:hPieConstraints];
  [self.viewConstraints addObjectsFromArray:vPieConstraints];
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

-(DLPieChart *)newPieChartView{
  DLPieChart *view = [[DLPieChart alloc] initWithFrame:CGRectMake(0, 0, 140, 140) Center:CGPointMake(240, 80) Radius:60];
  [view setTranslatesAutoresizingMaskIntoConstraints:NO]; 
  [view setShowLabel:NO]; 
  [view setDelegate:self];
  [view setDataSource:self];
  return view; 
}

#pragma mark Pie Chart Delegate

- (NSUInteger)numberOfSlicesInPieChart:(DLPieChart *)pieChart{
  return 3; 
}
- (CGFloat)pieChart:(DLPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:
                               [NSNumber numberWithFloat:20.0f],
                               [NSNumber numberWithFloat:30.0f],
                               [NSNumber numberWithFloat:50.0f],
                               nil];

  return [[dataArray objectAtIndex:index] floatValue];
}

- (UIColor *)pieChart:(DLPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *colorArray = [NSMutableArray arrayWithObjects:
                                [UIColor colorWithRed:1.0f green:.71f blue:.20f alpha:1.0f],
                                [UIColor colorWithRed:.29f green:.51f blue:.72f alpha:1.0f],
                                [UIColor colorWithWhite:.33f alpha:1.0f],
                                nil];
  return [colorArray objectAtIndex:index];
}

- (NSString *)pieChart:(DLPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
  NSMutableArray *textArray = [NSMutableArray arrayWithObjects:
                          @"Well",
                          @"Medium",
                          @"Small",
                          nil];
  return [textArray objectAtIndex:index];
}



@end
