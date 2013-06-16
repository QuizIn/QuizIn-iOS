
#import "QICalendarPickerView.h"
#import "QICalendarCellView.h"

#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75
#define PAN_CLOSED_X 0
#define PAN_OPEN_X -50

@interface QICalendarPickerView ()

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedTableRows;

@end

@implementation QICalendarPickerView

@synthesize tableView=_tableView;
@synthesize openCellLastTX, openCellIndexPath;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _tableView = [[UITableView alloc] initWithFrame:CGRectMake(20.0, 30.0, 280.0, 400.0) style:UITableViewStylePlain];
      self.tableView.dataSource = self;
      _selectedTableRows =[NSMutableArray array];
      for (int i = 0; i<30 ; i++){
        [_selectedTableRows addObject:[NSNumber numberWithBool:NO]];
      }
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
  [self addSubview:self.tableView];
}
#pragma Data Display

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//  return @[@"Today",@"Tomorrow",@"Day After Tomorrow"];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ 
  return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"CustomCell";
  
  QICalendarCellView *cell = (QICalendarCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil){
    cell = [[QICalendarCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    cell.frontView.backgroundColor = [UIColor redColor];
    cell.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 44)];
    cell.backView.backgroundColor = [UIColor blueColor];
    [cell.backView addSubview:cell.frontView];
    [cell.contentView addSubview:cell.backView];
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
  NSIndexPath *indexPath = [self.tableView indexPathForCell:(QICalendarCellView *)[panGestureRecognizer view] ];
  UIView *view = ((QICalendarCellView *)panGestureRecognizer.view).frontView;
  
  switch ([panGestureRecognizer state]) {
    case UIGestureRecognizerStateBegan:
      if (self.openCellIndexPath.section != indexPath.section || self.openCellIndexPath.row != indexPath.row) {
        //[self snapView:((QICalendarCellView *)[self.tableView cellForRowAtIndexPath:self.openCellIndexPath]).frontView toX:PAN_CLOSED_X animated:YES];
        [self setOpenCellIndexPath:nil];
        [self setOpenCellLastTX:0];
      }
      break;
    case UIGestureRecognizerStateEnded:
      vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self].x;
      compare = view.transform.tx + vX;
      if (compare > threshold) {
        finalX = MAX(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:0];
      } else {
        finalX = MIN(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:view.transform.tx];
      }
      [self snapView:view toX:finalX animated:YES];
      if (finalX == PAN_CLOSED_X) {
        [self setOpenCellIndexPath:nil];
      } else {
        [self setOpenCellIndexPath:[self.tableView indexPathForCell:(QICalendarCellView *)panGestureRecognizer.view]];
      }
      break;
    case UIGestureRecognizerStateChanged:
      compare = self.openCellLastTX+[panGestureRecognizer translationInView:self].x;
      if (compare > MAX(PAN_OPEN_X,PAN_CLOSED_X)){
        compare = MAX(PAN_OPEN_X,PAN_CLOSED_X);
        [self.selectedTableRows replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
      }
      else if (compare < MIN(PAN_OPEN_X,PAN_CLOSED_X)){
        compare = MIN(PAN_OPEN_X,PAN_CLOSED_X);
        [self.selectedTableRows replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:YES]];
      }
      [view setTransform:CGAffineTransformMakeTranslation(compare, 0)];
      break;
    default:
      break;
  }
}

-(void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated
{
  
  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:FAST_ANIMATION_DURATION];
  }
  
  [view setTransform:CGAffineTransformMakeTranslation(x, 0)];
  
  if (animated) {
    [UIView commitAnimations];
  }
}

#pragma mark -  
#pragma UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)sender {
  if ([sender isEqual:[self tableView]]) {
    QICalendarCellView *openCell = (QICalendarCellView *) [self.tableView cellForRowAtIndexPath:self.openCellIndexPath];
    //[self snapView:openCell.frontView toX:PAN_CLOSED_X animated:YES];
  }
}



@end