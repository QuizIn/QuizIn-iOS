
#import "QIStatsView.h"
#import "QIStatsCellView.h"
#import "QIStatsTableHeaderView.h"
#import "QIStatsSummaryView.h"

@interface QIStatsView ()


@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) QIStatsTableHeaderView *headerView;
@property (nonatomic, strong) QIStatsSummaryView *summaryView; 
@property (nonatomic, retain) NSMutableArray *viewConstraints;
@property (nonatomic, strong) NSLayoutConstraint *vSummaryViewConstraint;
@property (nonatomic, assign) NSUInteger lastContentOffset; 

@end

@implementation QIStatsView
+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _viewBackground = [self newViewBackground];
      _headerView = [self newHeaderView];
      _tableView = [self newStatsTable];
      _summaryView = [self newStatsSummaryView];
      
      _resetStatsButton = [self newResetStatsButton];
      _printStatsButton = [self newPrintStatsButton];
      
      [self contstructViewHierarchy];
    }
    return self;
}

#pragma mark Properties

- (void)setCurrentRank:(int)currentRank {
  _currentRank = currentRank;
}

- (void)setTotalCorrectAnswers:(int)totalCorrectAnswers{
  _totalCorrectAnswers = totalCorrectAnswers;
}

- (void)setTotalIncorrectAnswers:(int)totalIncorrectAnswers{
  _totalIncorrectAnswers = totalIncorrectAnswers;
}

- (void)setConnectionStats:(NSArray *)connectionStats{
  if ([_connectionStats isEqualToArray:connectionStats]) {
    return;
  }
  _connectionStats = [connectionStats copy];
}

#pragma mark Layout
- (void)contstructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.tableView];
  [self addSubview:self.resetStatsButton];
  [self addSubview:self.printStatsButton];
  [self addSubview:self.summaryView];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.viewConstraints) {
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
    NSDictionary *mainViews = NSDictionaryOfVariableBindings(_tableView,_summaryView);
    
    NSArray *hTableViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_tableView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:mainViews];
    NSArray *vTableViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:[_summaryView(==200)][_tableView]|"
                                            options:0
                                            metrics:nil
                                              views:mainViews];
    
    [self.viewConstraints addObjectsFromArray:hTableViewContraints];
    [self.viewConstraints addObjectsFromArray:vTableViewContraints];
    
    //Constrain SummaryView

    NSArray *hSummaryViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_summaryView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:mainViews];

    NSLayoutConstraint *heightSummaryViewConstraint = [NSLayoutConstraint constraintWithItem:_summaryView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:200.0f];
   
    _vSummaryViewConstraint = [NSLayoutConstraint constraintWithItem:_summaryView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    [self.viewConstraints addObjectsFromArray:hSummaryViewContraints];
    [self.viewConstraints addObjectsFromArray:@[_vSummaryViewConstraint,heightSummaryViewConstraint]];

    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

-(QIStatsTableHeaderView *)newHeaderView{
  QIStatsTableHeaderView *headerView = [[QIStatsTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
  headerView.sectionTitle = @"Heading Title - Link to worst-known quiz";
  return headerView;
}

-(QIStatsSummaryView *)newStatsSummaryView{
  QIStatsSummaryView *summaryView = [[QIStatsSummaryView alloc] init];
  [summaryView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return summaryView;
}

-(UITableView *)newStatsTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor clearColor]];
  [tableView setSeparatorColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [tableView setShowsVerticalScrollIndicator:NO];
  tableView.rowHeight = 46;
  tableView.sectionHeaderHeight = 25;
  tableView.tableHeaderView = self.headerView;
  tableView.dataSource = self;
  tableView.delegate = self;
  return tableView;
}

- (UIButton *)newResetStatsButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Reset Stats" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 335.0f, 150.0f, 15.0f);
  [statsViewButton setHidden:YES]; 
  return statsViewButton;
}

- (UIButton *)newPrintStatsButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Print Stats" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 350.0f, 150.0f, 15.0f);
  [statsViewButton setHidden:YES];
  return statsViewButton;
}

#pragma mark - Table view data source
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [UIView animateWithDuration:.5 animations:^{
    if (self.lastContentOffset > scrollView.contentOffset.y){
      [self.vSummaryViewConstraint setConstant:0];
    }
    else if (self.lastContentOffset < scrollView.contentOffset.y){
      [self.vSummaryViewConstraint setConstant:-170];
    }
    [self layoutIfNeeded];
  }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [[self.connectionStats objectAtIndex:0] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[[self.connectionStats objectAtIndex:1] objectForKey:[[self.connectionStats objectAtIndex:0] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  return [[self.connectionStats objectAtIndex:0] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  static NSString *cellIdentifier = @"CustomCell";
  QIStatsCellView *cell = (QIStatsCellView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QIStatsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  }
  NSDictionary *data = [[[self.connectionStats objectAtIndex:1] objectForKey:[[self.connectionStats objectAtIndex:0] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  int knowledgeIndex = [[data objectForKey:@"correctAnswers"] integerValue]-[[data objectForKey:@"incorrectAnswers"] integerValue];
  [cell setConnectionName:[NSString stringWithFormat:@"%@ %@",[data objectForKey:@"userFirstName"],[data objectForKey:@"userLastName"]]];
  [cell setKnowledgeIndex:[NSString stringWithFormat:@"%d",knowledgeIndex]];
  [cell setProfileImageURL:[NSURL URLWithString:[data objectForKey:@"userPictureURL"]]];
  [cell setRightAnswers:[NSString stringWithFormat:@"%d",[[data objectForKey:@"correctAnswers"] integerValue]]];
  [cell setWrongAnswers:[NSString stringWithFormat:@"%d",[[data objectForKey:@"incorrectAnswers"] integerValue]]];
  return cell;
}

@end
