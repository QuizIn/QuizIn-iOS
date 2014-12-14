#import "QIGroupSelectionView.h"
#import "QIGroupSelectionCellView.h"
#import "QIGroupSelectionData.h"
#import "QIFontProvider.h"

#define FAST_ANIMATION_DURATION 0.35
#define SLOW_ANIMATION_DURATION 0.75
#define PAN_CLOSED_X 0
#define PAN_OPEN_X -28

@interface QIGroupSelectionView ()

@property (nonatomic, strong) UILabel *viewLabel; 
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topSlit;
@property (nonatomic, strong) UIImageView *bottomSlit;
@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic) float openCellLastTX;
@property (nonatomic, strong) NSIndexPath *openCellIndexPath;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

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
      _footerView = [self newFooterView];
      _tableView = [self newSelectionTable];
      _topSlit = [self newTopSlit];
      _bottomSlit = [self newBottomSlit];
      _viewBackground = [self newViewBackground];
      _quizButton = [self newQuizButton];
      _backButton = [self newBackButton];
      _activityView = [self newActivityView];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma properties
-(void) setSelectionContent:(NSMutableArray *)selectionContent {
  if ([selectionContent isEqualToArray:_selectionContent]) {
    return;
  }
  NSMutableArray *selectionContentTemp= [NSMutableArray array];
  if ([selectionContent count]>0){
    [self.activityView stopAnimating];
    selectionContentTemp = [self removeDuplicateSelectionContent:selectionContent];
  }
  
  _selectionContent = [selectionContentTemp mutableCopy];
  [self.tableView reloadData];
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
  [self addSubview:self.backButton];
  [self addSubview:self.activityView];
  [self.tableView setTableFooterView:self.footerView];
}
#pragma Data Display

-(void)updateViewLabel{
    self.viewLabel.text = self.selectionViewLabelString;
}

- (NSMutableArray *)removeDuplicateSelectionContent: (NSMutableArray *)possiblyDuplicated{
  
  NSMutableArray * itemsFiltered = [[NSMutableArray alloc] init];
  NSMutableArray * itemIDEncountered = [[NSMutableArray alloc] init];
  NSString * name;
  for (NSDictionary *item in [possiblyDuplicated reverseObjectEnumerator]){
    name = [item objectForKey:@"title"];
    if ([itemIDEncountered indexOfObject: name] == NSNotFound) {
      [itemIDEncountered addObject:name];
      [itemsFiltered addObject:item];   //And add the group to the list, as this is the first time it's encountered
    }
  }
  return [[[itemsFiltered reverseObjectEnumerator] allObjects] mutableCopy];
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
    NSDictionary *mainViews = NSDictionaryOfVariableBindings(_viewLabel, _topSlit,_tableView,_bottomSlit,_quizButton,_backButton,_activityView);
    
    NSArray *vMainViewsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_viewLabel(==20)]-3-[_topSlit(==8)]-(-5)-[_tableView]-(-5)-[_bottomSlit(==8)]-[_quizButton(==54)]-6-|"
                                            options:0
                                            metrics:0
                                              views:mainViews];
    
    NSArray *vActivityViewsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_topSlit]-60-[_activityView]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:0
                                              views:mainViews];
    
    NSArray *hLabelConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_backButton]-(>=8)-[_viewLabel]-8-|"
                                            options:NSLayoutFormatAlignAllBaseline
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
    
    NSLayoutConstraint *hButtonConstraint = [NSLayoutConstraint constraintWithItem:_quizButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];

    
    [self.viewConstraints addObjectsFromArray:hLabelConstraints];
    [self.viewConstraints addObjectsFromArray:hTopSlitConstraints];
    [self.viewConstraints addObjectsFromArray:hTableViewConstraints];
    [self.viewConstraints addObjectsFromArray:hBottomSlitConstraints];
    [self.viewConstraints addObjectsFromArray:vMainViewsConstraints];
    [self.viewConstraints addObjectsFromArray:vActivityViewsConstraints];
    [self.viewConstraints addObjectsFromArray:@[hButtonConstraint]];
    
    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark Strings

-(NSString *)backButtonTitle{
  return @"< Back";
}

#pragma mark Factory Methods

-(UITableView *)newSelectionTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor colorWithRed:.34f green:.45f blue:.64f alpha:.5f]];
  [tableView setSeparatorColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [tableView setShowsVerticalScrollIndicator:NO];
  tableView.separatorColor = [UIColor clearColor];
  tableView.rowHeight = 43;
  tableView.sectionHeaderHeight = 25;
  tableView.dataSource = self;
  tableView.delegate = self; 
  return tableView;
}

- (UIActivityIndicatorView *)newActivityView{
  UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [activity setHidesWhenStopped:YES];
  [activity setAlpha:.8f];
  [activity startAnimating];
  [activity setTranslatesAutoresizingMaskIntoConstraints:NO];
  return activity;
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

-(QIGroupSelectionTableFooterView *)newFooterView{
  QIGroupSelectionTableFooterView *footer = [[QIGroupSelectionTableFooterView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
  return footer;
}

- (UILabel *)newViewLabel {
  UILabel *viewLabel = [[UILabel alloc] init];
  viewLabel.textAlignment = NSTextAlignmentCenter;
  viewLabel.backgroundColor = [UIColor clearColor];
  viewLabel.font = [QIFontProvider fontWithSize:12.0f style:Bold];
  viewLabel.adjustsFontSizeToFitWidth = YES;
  viewLabel.textColor = [UIColor colorWithWhite:0.50f alpha:1.0f];
  [viewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
  return viewLabel;
}

- (UIButton *)newQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setBackgroundImage:[[UIImage imageNamed:@"connectionsquiz_hobnob_btn"] resizableImageWithCapInsets: UIEdgeInsetsMake(0, 5, 0, 200)] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  button.backgroundColor = [UIColor clearColor];
  return button;
}

- (UIButton *)newBackButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self backButtonTitle] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Bold]];
  [button setTitleColor:[UIColor colorWithWhite:0.50f alpha:1.0f] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateHighlighted];
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
  }
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  [cell.backView setBackgroundColor:[UIColor colorWithRed:.34f green:.45f blue:.64f alpha:1.0f]];
  //[cell setImageURLs:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"images"]];
  [cell setSelectionTitle:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"title"]];
  //[cell setSelectionSubtitle:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"subtitle"]];
  //[cell setLogoURL:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"logo"]];
  //[cell setNumberOfContacts:[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"contacts"]];
  
  BOOL selected = [[[self.selectionContent objectAtIndex:indexPath.row] objectForKey:@"selected"] boolValue];
  if (selected){
    [self snapViewforCell:cell toX:PAN_OPEN_X animated:NO];
  }
  else{
    [self snapViewforCell:cell toX:PAN_CLOSED_X animated:NO];
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
    [self snapViewforCell:cell toX:PAN_CLOSED_X animated:YES];
    [[self.selectionContent objectAtIndex:indexPath.row] setObject:@NO forKey:@"selected"];
  }
  else{
    [self snapViewforCell:cell toX:PAN_OPEN_X animated:YES];
     [[self.selectionContent objectAtIndex:indexPath.row] setObject:@YES forKey:@"selected"];
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
  
  switch ([panGestureRecognizer state]) {
    case UIGestureRecognizerStateBegan:
      if (self.openCellIndexPath.section != indexPath.section || self.openCellIndexPath.row != indexPath.row) {
        [self setOpenCellIndexPath:nil];
        [self setOpenCellLastTX:0];
      }
      break;
    case UIGestureRecognizerStateEnded:
      vX = (FAST_ANIMATION_DURATION/2.0)*[panGestureRecognizer velocityInView:self].x;
      compare = cellView.slideOffset + vX;
      if (compare > threshold) {
        finalX = MAX(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:0];
        [[self.selectionContent objectAtIndex:indexPath.row] setObject:@NO forKey:@"selected"];
      } else {
        finalX = MIN(PAN_OPEN_X,PAN_CLOSED_X);
        [self setOpenCellLastTX:cellView.slideOffset];
        [[self.selectionContent objectAtIndex:indexPath.row] setObject:@YES forKey:@"selected"];
      }
      [self snapViewforCell:cellView toX:finalX animated:YES];
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
      cellView.slideOffset = compare;
      break;
    default:
      compare = 0;
      break;
  }
}

-(void)snapViewforCell:(QIGroupSelectionCellView *)cell toX:(float)x animated:(BOOL)animated
{
  if (animated) {
    [UIView animateWithDuration:FAST_ANIMATION_DURATION animations:^{
      cell.slideOffset = x;
    }];
  }
  else {
    cell.slideOffset = x;
  }
  
}

@end