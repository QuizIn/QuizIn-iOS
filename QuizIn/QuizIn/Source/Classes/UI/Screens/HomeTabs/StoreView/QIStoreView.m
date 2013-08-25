#import "QIStoreView.h"
#import "QIStoreCellView.h"
#import "QIStoreTableHeaderView.h"
#import "QIStoreSectionHeaderView.h"
#import "QIRankDefinition.h"
#import "QIStoreData.h"

@interface QIStoreView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, retain) NSMutableArray *viewConstraints;

@end

@implementation QIStoreView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _viewBackground = [self newViewBackground];
    //_headerView = [self newHeaderView];
    //_tableView = [self newStoreTable];
    //_storeData = [QIStoreData getStoreData];
    
    [self contstructViewHierarchy];
  }
  return self;
}

#pragma mark Properties

- (void) setTableView:(UITableView *)tableView {
  _tableView = tableView;
}

#pragma mark Layout
- (void)contstructViewHierarchy{
  [self addSubview:self.viewBackground];
  //[self addSubview:self.tableView];
}

#pragma mark Layout

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

#pragma mark Actions
-(void)buy:(UIButton *)button{
  NSLog(@"%d",button.tag);
 // QIStorePreviewViewController *previewController = [[QIStorePreviewViewController alloc] init];
}
-(void)preview:(UIButton *)button{
  NSLog(@"%d",button.tag); 
}

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}






@end
