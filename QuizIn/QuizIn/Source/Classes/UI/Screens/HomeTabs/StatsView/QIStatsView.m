
#import "QIStatsView.h"

#define SUMMARY_OFFSET -160

@interface QIStatsView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, retain) NSMutableArray *viewConstraints;
@property (nonatomic, strong) NSLayoutConstraint *vSummaryViewConstraint;
@property (nonatomic, assign) BOOL toggleIndexForTable; 

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
      _summaryView = [self newStatsSummaryView];
      _tableView = [self newStatsTable];
      _toggleIndexForTable = NO;
 
      
      _resetStatsButton = [self newResetStatsButton];
      _printStatsButton = [self newPrintStatsButton];
      
      [self contstructViewHierarchy];
    }
    return self;
}

#pragma mark Properties

- (void)setCurrentRank:(int)currentRank {
  _currentRank = currentRank;
  [self updateCurrentRank];
}

- (void)setTotalCorrectAnswers:(int)totalCorrectAnswers{
  _totalCorrectAnswers = totalCorrectAnswers;
  [self updateCorrectAnswers]; 
}

- (void)setTotalIncorrectAnswers:(int)totalIncorrectAnswers{
  _totalIncorrectAnswers = totalIncorrectAnswers;
  [self updateIncorrectAnswers]; 
}

- (void)setConnectionStats:(NSArray *)connectionStats{
  if ([_connectionStats isEqualToArray:connectionStats]) {
    return;
  }
  _connectionStats = [connectionStats copy];
}

#pragma mark Data Layout
- (void)updateCorrectAnswers{
  [self.summaryView setCorrectAnswers:[NSString stringWithFormat:@"Correct Answers: %d", self.totalCorrectAnswers]];
}

- (void)updateIncorrectAnswers{
  [self.summaryView setIncorrectAnswers:[NSString stringWithFormat:@"Incorrect Answers: %d", self.totalIncorrectAnswers]]; 
}

- (void)updateCurrentRank{
  [self.summaryView setCurrentRank:[NSString stringWithFormat:@"Current Rank: %d", self.currentRank]];
}

#pragma mark Layout
- (void)contstructViewHierarchy{
  [self addSubview:self.viewBackground];
  [self addSubview:self.tableView];
  [self addSubview:self.resetStatsButton];
  [self addSubview:self.printStatsButton];
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
    NSDictionary *mainViews = NSDictionaryOfVariableBindings(_tableView);
    
    NSArray *hTableViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_tableView]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:mainViews];

    NSArray *vTableViewContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_tableView]|"
                                            options:0
                                            metrics:nil
                                              views:mainViews];
    
    [self.viewConstraints addObjectsFromArray:hTableViewContraints];
    [self.viewConstraints addObjectsFromArray:vTableViewContraints];
  
    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

-(QIStatsSummaryView *)newStatsSummaryView{
  QIStatsSummaryView *summaryView = [[QIStatsSummaryView alloc] initWithFrame:CGRectMake(0,0,320,200)];
  return summaryView;
}

-(UITableView *)newStatsTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor clearColor]];
  [tableView setSeparatorColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [tableView setShowsVerticalScrollIndicator:NO];
  [tableView setRowHeight:46];
  [tableView setSectionHeaderHeight:40];
  [tableView setTableHeaderView:self.summaryView];
  [tableView setDataSource:self];
  [tableView setDelegate:self];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
  BOOL compare = self.toggleIndexForTable;
  self.toggleIndexForTable = scrollView.contentOffset.y >= 200;
  if (compare != self.toggleIndexForTable){
    [self.tableView reloadData];
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [[self.connectionStats objectAtIndex:0] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  QIStatsSectionHeaderView *headerView = [[QIStatsSectionHeaderView alloc] init];
  headerView.sectionTitle = @"Section Title"; 
  return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[[self.connectionStats objectAtIndex:1] objectForKey:[[self.connectionStats objectAtIndex:0] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
  return [[self.connectionStats objectAtIndex:0] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
  if (tableView.contentOffset.y >=200){
    return [self.connectionStats objectAtIndex:0];
  }
  else {
    return nil; 
  }
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
