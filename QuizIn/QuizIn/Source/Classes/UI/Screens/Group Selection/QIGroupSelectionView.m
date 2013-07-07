#import "QIGroupSelectionView.h"
#import "QIGroupSelectionCellView.h"
#import "QIGroupSelectionData.h"
#import "QIGroupSelectionTableFooterView.h"
#import "QIFontProvider.h"

#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75
#define PAN_CLOSED_X 0
#define PAN_OPEN_X -45

@interface QIGroupSelectionView ()

@property (nonatomic, strong) UILabel *viewLabel; 
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topSlit;
@property (nonatomic, strong) UIImageView *bottomSlit;
@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic, strong) QIGroupSelectionTableFooterView *footerViewLoading;
@property (nonatomic) float openCellLastTX;
@property (nonatomic, strong) NSIndexPath *openCellIndexPath;

@end

@implementation QIGroupSelectionView

@synthesize openCellLastTX, openCellIndexPath;

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewLabel = [self newViewLabel];
      _footerViewLoading = [self newFooterViewLoading];
      _tableView = [self newSelectionTable];
      _topSlit = [self newTopSlit];
      _bottomSlit = [self newBottomSlit];
      _viewBackground = [self newViewBackground];
      _quizButton = [self newQuizButton];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma properties
-(void) setSelectionContent:(NSMutableArray *)selectionContent {
  if ([selectionContent isEqualToArray:_selectionContent]) {
    return;
  }
  _selectionContent = selectionContent;
}

-(void) setSelectionViewLabelString:(NSString *)selectionViewLabelString {
  if ([selectionViewLabelString isEqualToString:_selectionViewLabelString]){
    return;
  }
  _selectionViewLabelString = selectionViewLabelString;
  [self updateViewLabel];
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self addSubview:self.viewBackground];
  [self addSubview:self.viewLabel];
  [self addSubview:self.tableView];
  [self addSubview:self.topSlit];
  [self addSubview:self.bottomSlit];
  [self addSubview:self.quizButton];
  [self.tableView setTableFooterView:self.footerViewLoading];
}
#pragma Data Display

-(void)updateViewLabel{
    self.viewLabel.text = self.selectionViewLabelString;
}
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
    NSDictionary *mainViews = NSDictionaryOfVariableBindings(_viewLabel, _topSlit,_tableView,_bottomSlit,_quizButton);
    
    NSArray *vMainViewsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_viewLabel(==20)]-3-[_topSlit(==8)]-(-5)-[_tableView]-(-5)-[_bottomSlit(==8)]-[_quizButton(==54)]-6-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_viewLabel]-8-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hTopSlitConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_topSlit]-8-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hTableViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_tableView]-15-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hBottomSlitConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_bottomSlit]-8-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    NSArray *hButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_quizButton]-14-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    
    [self.viewConstraints addObjectsFromArray:hLabelConstraints];
    [self.viewConstraints addObjectsFromArray:hTopSlitConstraints];
    [self.viewConstraints addObjectsFromArray:hTableViewConstraints];
    [self.viewConstraints addObjectsFromArray:hBottomSlitConstraints];
    [self.viewConstraints addObjectsFromArray:vMainViewsConstraints];
    [self.viewConstraints addObjectsFromArray:hButtonConstraints];
    
    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark Strings
-(NSString *)quizButtonTitle{
  return @"Take Quiz";
}
#pragma mark Factory Methods

-(UITableView *)newSelectionTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor colorWithRed:80.0f/255.0f green:125.0f/255.0f blue:144.0f/255.0f alpha:.3f]];
  [tableView setSeparatorColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [tableView setShowsVerticalScrollIndicator:NO];
  tableView.rowHeight = 94;
  tableView.sectionHeaderHeight = 25;
  tableView.dataSource = self;
  tableView.delegate = self; 
  return tableView;
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

-(QIGroupSelectionTableFooterView *)newFooterViewLoading{
  QIGroupSelectionTableFooterView *footer = [[QIGroupSelectionTableFooterView alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
  return footer;
}

- (UILabel *)newViewLabel {
  UILabel *viewLabel = [[UILabel alloc] init];
  viewLabel.textAlignment = NSTextAlignmentLeft;
  viewLabel.backgroundColor = [UIColor clearColor];
  viewLabel.font = [QIFontProvider fontWithSize:15.0f style:Bold];
  viewLabel.adjustsFontSizeToFitWidth = YES;
  viewLabel.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [viewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return viewLabel;
}

- (UIButton *)newQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self quizButtonTitle] forState:UIControlStateNormal];
  [button setBackgroundImage:[[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 74, 0, 74)] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  button.backgroundColor = [UIColor clearColor];
  return button;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.selectionContent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  static NSString *cellIdentifier = @"CustomCell";
  QIGroupSelectionCellView *cell = (QIGroupSelectionCellView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QIGroupSelectionCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.backView setBackgroundColor:[UIColor colorWithRed:80.0f/255.0f green:125.0f/255.0f blue:144.0f/255.0f alpha:1.0f]];
    [cell setImageURLs:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"images"]];
    [cell setSelectionTitle:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [cell setSelectionSubtitle:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"subtitle"]];
    [cell setLogoURL:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"logo"]];
    [cell setNumberOfContacts:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"contacts"]];
  }
  
  BOOL selected = [[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"selected"] boolValue];
  if (selected){
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  QIGroupSelectionCellView *cell = (QIGroupSelectionCellView *)[tableView cellForRowAtIndexPath:indexPath];

  BOOL selected = [[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"selected"] boolValue];
  if (selected){
    [self snapView:cell.frontView toX:PAN_CLOSED_X animated:YES];
    [[self.selectionContent objectAtIndex:indexPath.row] setObject:@NO forKey:@"selected"];
  }
  else{
    [self snapView:cell.frontView toX:PAN_OPEN_X animated:YES];
     [[self.selectionContent objectAtIndex:indexPath.row] setObject:@YES forKey:@"selected"];
  }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
  NSArray *visibleRows = [self.tableView visibleCells];
  UITableViewCell *lastVisibleCell = [visibleRows lastObject];
  NSIndexPath *path = [self.tableView indexPathForCell:lastVisibleCell];
  if(path.row == [self.selectionContent count]-1)
  {
    [self.selectionContent addObjectsFromArray:[QIGroupSelectionData getSelectionData]];
    [self.tableView reloadData];
  }
}

#pragma mark - Gesture recognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
  QIGroupSelectionCellView *cell = (QIGroupSelectionCellView *)[panGestureRecognizer view];
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
  NSIndexPath *indexPath = [self.tableView indexPathForCell:(QIGroupSelectionCellView *)[panGestureRecognizer view] ];
  QIGroupSelectionCellView *cellView = (QIGroupSelectionCellView *)[self.tableView cellForRowAtIndexPath:indexPath];
  UIView *frontView = ((QIGroupSelectionCellView *)panGestureRecognizer.view).frontView;
  
  switch ([panGestureRecognizer state]) {
    case UIGestureRecognizerStateBegan:
      if (self.openCellIndexPath.section != indexPath.section || self.openCellIndexPath.row != indexPath.row) {
        [self setOpenCellIndexPath:nil];
        [self setOpenCellLastTX:0];
      }
      break;
    case UIGestureRecognizerStateEnded:
      vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self].x;
      compare = cellView.slideOffset.constant + vX;
      if (compare > threshold) {
        finalX = MAX(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:0];
        [[self.selectionContent objectAtIndex:indexPath.row] setObject:@NO forKey:@"selected"];
      } else {
        finalX = MIN(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:cellView.slideOffset.constant];
        [[self.selectionContent objectAtIndex:indexPath.row] setObject:@YES forKey:@"selected"];
      }
      [self snapView:frontView toX:finalX animated:YES];
      if (finalX == PAN_CLOSED_X) {
        [self setOpenCellIndexPath:nil];
      }
      else {
        [self setOpenCellIndexPath:[self.tableView indexPathForCell:(QIGroupSelectionCellView *)panGestureRecognizer.view]];
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
      //[view setTransform:CGAffineTransformMakeTranslation(compare, 0)];
      [cellView.slideOffset setConstant:compare];
      [self layoutIfNeeded];
      break;
    default:
      compare = 0;
      break;
  }
}

-(void)snapView:(UIView *)view toX:(float)x animated:(BOOL)animated
{
  QIGroupSelectionCellView *cell = (QIGroupSelectionCellView *)view.superview.superview.superview;
  
  if (animated) {
    [UIView animateWithDuration:FAST_ANIMATION_DURATION animations:^{
      [cell.slideOffset setConstant:x];
      [self layoutIfNeeded];
    }];
  }
  else {
    [cell.slideOffset setConstant:x];
    [self layoutIfNeeded];
  }

}

@end