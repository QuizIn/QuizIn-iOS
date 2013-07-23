
#import "QIStatsView.h"
#import "QIStatsCellView.h"
#import "QIStatsTableHeaderView.h"

@interface QIStatsView ()


@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) QIStatsTableHeaderView *headerView; 
@property (nonatomic, retain) NSMutableArray *viewConstraints;

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
      
      _resetStatsButton = [self newResetStatsButton];
      _addStatsButton = [self newAddStatsButton];
      _printStatsButton = [self newPrintStatsButton];
      
      [self contstructViewHierarchy];
    }
    return self;
}

#pragma mark Properties
- (void)setCurrentUser:(NSMutableDictionary *)currentUser{
  _currentUser = currentUser;
}

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
  [self addSubview:self.addStatsButton];
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

-(QIStatsTableHeaderView *)newHeaderView{
  QIStatsTableHeaderView *headerView = [[QIStatsTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  headerView.sectionTitle = @"Heading Title";
  return headerView;
}

-(UITableView *)newStatsTable{
  UITableView *tableView = [[UITableView alloc] init];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor colorWithRed:80.0f/255.0f green:125.0f/255.0f blue:144.0f/255.0f alpha:.3f]];
  [tableView setSeparatorColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [tableView setShowsVerticalScrollIndicator:NO];
  tableView.rowHeight = 94;
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
  return statsViewButton;
}

- (UIButton *)newPrintStatsButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Print Stats" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 350.0f, 150.0f, 15.0f);
  return statsViewButton;
}

- (UIButton *)newAddStatsButton {
  UIButton *statsViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [statsViewButton setTitle:@"Add Stats" forState:UIControlStateNormal];
  statsViewButton.frame = CGRectMake(200.0f, 365.0f, 150.0f, 15.0f);
  return statsViewButton;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [self.connectionStats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

  NSDictionary *data = [self.connectionStats objectAtIndex:indexPath.row];
  static NSString *cellIdentifier = @"CustomCell";
  QIStatsCellView *cell = (QIStatsCellView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil){
    cell = [[QIStatsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setConnectionName:[NSString stringWithFormat:@"%@ %@",[data objectForKey:@"userFirstName"],[data objectForKey:@"userLastName"]]];
    [cell setKnowledgeIndex:[NSString stringWithFormat:@"%d",[[data objectForKey:@"correctAnswers"] integerValue]]];
    [cell setProfileImageURL:[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_80_80/p/1/000/080/035/28eea75.jpg"]];
  }
  return cell;
}

@end
