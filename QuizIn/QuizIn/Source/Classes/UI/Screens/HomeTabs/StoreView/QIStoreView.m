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
    _activity = [self newActivityView]; 
    _storeStatusLabel = [self newStoreStatusLabel];
    _refreshButton = [self newRefreshButton]; 
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

#pragma mark factory methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
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


@end
