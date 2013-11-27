#import "QIStoreView.h"
#import "QIStoreCellView.h"
#import "QIStoreTableHeaderView.h"
#import "QIStoreSectionHeaderView.h"
#import "QIRankDefinition.h"
#import "QIStoreData.h"
#import "QIFontProvider.h"

@interface QIStoreView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *viewConstraints;
@property (nonatomic, strong) UIActivityIndicatorView *overlaySpinner;
@property (nonatomic, strong) UILabel *purchasingStatusLabel;


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
    _spinningOverlay = [self newSpinningOverlay];
    _overlaySpinner = [self newOverlayActivityView];
    _purchasingStatusLabel = [self newPurchaseStatusLabel];
    _activity = [self newActivityView]; 
    _storeStatusLabel = [self newStoreStatusLabel];
    _refreshButton = [self newRefreshButton];
    _headerView = [self newHeaderView];
    _footerView = [self newFooterView];
    _tableView = [self newStoreTable];
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
  [self addSubview:self.activity];
  [self addSubview:self.storeStatusLabel];
  [self addSubview:self.refreshButton];
  [self addSubview:self.tableView];
  [self addSubview:self.spinningOverlay];
  [self.spinningOverlay addSubview:self.overlaySpinner];
  [self.spinningOverlay addSubview:self.purchasingStatusLabel];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}


- (void)updateConstraints {
  [super updateConstraints];
  if (!self.viewConstraints) {
    NSDictionary *backgroundImageConstraintView = NSDictionaryOfVariableBindings(_viewBackground,_spinningOverlay);
    
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
    
    
    //Constrain Overlay Elements
    
    NSArray *hOverlayContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_spinningOverlay]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    NSArray *vOverlayContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_spinningOverlay]|"
                                            options:0
                                            metrics:nil
                                              views:backgroundImageConstraintView];
    
    [self.viewConstraints addObjectsFromArray:hOverlayContraints];
    [self.viewConstraints addObjectsFromArray:vOverlayContraints];
    
    //Constrain Loading items
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_overlaySpinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_spinningOverlay attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_overlaySpinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_spinningOverlay attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_purchasingStatusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_spinningOverlay attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_purchasingStatusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_spinningOverlay attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30.0f]];
    
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
    
    //Constrain Loading items
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_activity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_activity attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_storeStatusLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_storeStatusLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:30.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_refreshButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [self.viewConstraints addObject:[NSLayoutConstraint constraintWithItem:_refreshButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:50.0f]];
    
    [self addConstraints:self.viewConstraints];
  }
}

#pragma mark strings
- (NSString *)storeStatusString{
  return @"Loading Store Items..."; 
}

- (NSString *)purchaseStatusString{
  return @"Purchasing Item...";
}

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UIView *)newSpinningOverlay{
  UIView *overlay = [[UIView alloc] init];
  [overlay setAlpha:.7f];
  [overlay setBackgroundColor:[UIColor blackColor]]; 
  [overlay setTranslatesAutoresizingMaskIntoConstraints:NO];
  return overlay; 
}

- (UILabel *)newPurchaseStatusLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:20.0f style:Bold]];
  [label setTextColor:[UIColor colorWithWhite:.9f alpha:1.0f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setText:[self purchaseStatusString]];
  return label;
}

- (UIActivityIndicatorView *)newOverlayActivityView{
  UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [activity setHidesWhenStopped:YES];
  [activity setAlpha:.8f];
  [activity startAnimating];
  [activity setTranslatesAutoresizingMaskIntoConstraints:NO];
  return activity;
}

- (UIActivityIndicatorView *)newActivityView{
  UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [activity setHidesWhenStopped:YES];
  [activity setAlpha:.8f]; 
  [activity startAnimating];
  [activity setTranslatesAutoresizingMaskIntoConstraints:NO];
  return activity; 
}

- (UILabel *)newStoreStatusLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setFont:[QIFontProvider fontWithSize:20.0f style:Bold]];
  [label setTextColor:[UIColor colorWithWhite:.5f alpha:.5f]];
  [label setAdjustsFontSizeToFitWidth:YES];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setText:[self storeStatusString]];
  return label;
}

- (UIButton *)newRefreshButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:@"Refresh" forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:12.0f style:Regular]];
  [button setTitleColor:[UIColor colorWithWhite:0.33f alpha:1.0f] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateHighlighted];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setHidden:YES]; 
  button.backgroundColor = [UIColor clearColor];
  return button;
}

-(UITableView *)newStoreTable{
  UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor clearColor]];
  [tableView setBackgroundView:nil];
  [tableView setOpaque:NO];
  [tableView setSeparatorColor:[UIColor clearColor]];
  [tableView setShowsVerticalScrollIndicator:NO];
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  [tableView setAllowsSelection:YES];
  tableView.rowHeight = 107;
  tableView.sectionHeaderHeight = 25;
  tableView.tableHeaderView = self.headerView;
  tableView.tableFooterView = self.footerView; 
  return tableView;
}

- (QIStoreTableHeaderView *)newHeaderView{
  QIStoreTableHeaderView *headerView = [[QIStoreTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
  [headerView setBackgroundColor:[UIColor clearColor]];
  return headerView;
}

- (QIStoreTableFooterView *)newFooterView{
  QIStoreTableFooterView *footerView = [[QIStoreTableFooterView alloc] initWithFrame:CGRectMake(0,0, 320, 30)];
  [footerView setBackgroundColor:[UIColor colorWithWhite:.33f alpha:0.2f]];
  return footerView; 
}


@end
