
#import "QICalendarPickerView.h"
#import "QICalendarCellView.h"

#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75
#define PAN_CLOSED_X 0
#define PAN_OPEN_X -50

@interface QICalendarPickerView ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedTableRows;
@property (nonatomic, strong) UIImageView *topSlit;
@property (nonatomic, strong) UIImageView *bottomSlit;
@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *viewConstraints; 

@end

@implementation QICalendarPickerView

@synthesize tableView=_tableView;
@synthesize openCellLastTX, openCellIndexPath;

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _tableView = [self newCalendarTable];
      _selectedTableRows = [self newSelectionArray];
      _topSlit = [self newTopSlit];
      _bottomSlit = [self newBottomSlit];
      _viewBackground = [self newViewBackground];
      
      //[self setTranslatesAutoresizingMaskIntoConstraints:NO];
      [self constructViewHierarchy];
    }
    return self;
}

#pragma properties
-(void) setCalendarContent:(NSMutableArray *)calendarContent {
  if ([calendarContent isEqualToArray:_calendarContent]) {
    return;
  }
  _calendarContent = calendarContent;
  //[self loadCalendarData];
}
#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self addSubview:self.viewBackground];
  [self addSubview:self.tableView];
  [self addSubview:self.topSlit];
  [self addSubview:self.bottomSlit];
}
#pragma Data Display

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.viewConstraints) {
    
    //Constrain Background
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_viewBackground]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    self.viewConstraints = [NSMutableArray array];
    [self.viewConstraints addObjectsFromArray:hBackgroundContraints];
    [self.viewConstraints addObjectsFromArray:vBackgroundContraints];
 
    
    //Constrain Main View Elements
    NSDictionary *mainViews = NSDictionaryOfVariableBindings(_topSlit,_tableView,_bottomSlit);
    
    NSArray *vMainViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_topSlit(==8)][_tableView][_bottomSlit(==8)]-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hTopSlit =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_topSlit]-8-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    

    NSArray *hTableView =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_tableView]-30-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    

    NSArray *hBottomSlit =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_bottomSlit]-8-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];

    
    [self.viewConstraints addObjectsFromArray:hTopSlit];
    [self.viewConstraints addObjectsFromArray:hTableView];
    [self.viewConstraints addObjectsFromArray:hBottomSlit];
    [self.viewConstraints addObjectsFromArray:vMainViews];
    
    [self addConstraints:self.viewConstraints];
  }
  
}


#pragma Factory Methods

-(UITableView *)newCalendarTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  tableView.dataSource = self;
  return tableView;
}

- (NSMutableArray *)newSelectionArray{
  NSMutableArray *selection = [NSMutableArray array];
  for (int i = 0; i<30 ; i++){
    [selection addObject:[NSNumber numberWithBool:NO]];
  }
  return [selection mutableCopy];
}

-(UIImageView *)newTopSlit{
  UIImageView *slit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_slittop"]];
  [slit setTranslatesAutoresizingMaskIntoConstraints:NO];
  return slit;
}

-(UIImageView *)newBottomSlit{
  UIImageView *slit = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_slitbottom"]];
  [slit setTranslatesAutoresizingMaskIntoConstraints:NO];
  return slit;
}

-(UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
  return 30;
}

- (NSInteger)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 94;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CustomCell";
  
  QICalendarCellView *cell = (QICalendarCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil){
    cell = [[QICalendarCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  }
  
  if ([[self.selectedTableRows objectAtIndex:indexPath.row] boolValue]){
    [self snapView:cell.frontView toX:PAN_OPEN_X animated:NO];
  }
  else{
    [self snapView:cell.frontView toX:PAN_CLOSED_X animated:NO];
  }

  UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  [panGestureRecognizer setDelegate:self];
  [cell addGestureRecognizer:panGestureRecognizer];
  
  return cell;
}

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
  QICalendarCellView *cell = (QICalendarCellView *)[panGestureRecognizer view];
  CGPoint translation = [panGestureRecognizer translationInView:[cell superview] ];
  return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
}

#pragma mark - Gesture handlers

-(void)handlePan:(UIPanGestureRecognizer *)panGestureRecognizer
{
  float threshold = (PAN_OPEN_X+PAN_CLOSED_X)/2.0;
  float vX = 0.0;
  float compare;
  float finalX;
  float alphaTrim; 
  NSIndexPath *indexPath = [self.tableView indexPathForCell:(QICalendarCellView *)[panGestureRecognizer view] ];
  UIView *view = ((QICalendarCellView *)panGestureRecognizer.view).frontView;
  
  switch ([panGestureRecognizer state]) {
    case UIGestureRecognizerStateBegan:
      if (self.openCellIndexPath.section != indexPath.section || self.openCellIndexPath.row != indexPath.row) {
        [self setOpenCellIndexPath:nil];
        [self setOpenCellLastTX:0];
      }
      alphaTrim = 0;
      break;
    case UIGestureRecognizerStateEnded:
      vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self].x;
      compare = view.transform.tx + vX;
      if (compare > threshold) {
        finalX = MAX(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:0];
        [self.selectedTableRows replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
      } else {
        finalX = MIN(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:view.transform.tx];
        [self.selectedTableRows replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
      }
      [self snapView:view toX:finalX animated:YES];
      alphaTrim = finalX/PAN_OPEN_X;
      if (finalX == PAN_CLOSED_X) {
        [self setOpenCellIndexPath:nil];
      }
      else {
        [self setOpenCellIndexPath:[self.tableView indexPathForCell:(QICalendarCellView *)panGestureRecognizer.view]];
      }
      
      break;
    case UIGestureRecognizerStateChanged:
      compare = self.openCellLastTX+[panGestureRecognizer translationInView:self].x;
      if (compare > MAX(PAN_OPEN_X,PAN_CLOSED_X)){
        compare = MAX(PAN_OPEN_X,PAN_CLOSED_X);
      }
      else if (compare < MIN(PAN_OPEN_X,PAN_CLOSED_X)){
        compare = MIN(PAN_OPEN_X,PAN_CLOSED_X);
      }
      [view setTransform:CGAffineTransformMakeTranslation(compare, 0)];
      alphaTrim = compare/PAN_OPEN_X;
      break;
    default:
      compare = 0;
      alphaTrim = 0;
      break;
  }

  view.superview.backgroundColor = [UIColor colorWithWhite:0.1 alpha:alphaTrim];
}

-(void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated
{
  
  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:FAST_ANIMATION_DURATION];
  }
  
  [view setTransform:CGAffineTransformMakeTranslation(x, 0)];
  view.superview.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
  
  if (animated) {
    [UIView commitAnimations];
  }
}



@end