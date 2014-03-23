#import "QISearchPickerView.h"

#import <FLKAutoLayout/UIView+FLKAutoLayout.h>

#import "QILayoutGuideProvider.h"

@interface QISearchPickerView ()

@property (nonatomic, strong, readwrite) UISearchBar *searchBar;
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong, readwrite) UIButton *exitButton;
@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, weak) id<QILayoutGuideProvider> layoutGuideProvider;
@property (nonatomic, assign) BOOL needsConstraints;

@end

@implementation QISearchPickerView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
    layoutGuideProvider:(id<QILayoutGuideProvider>)layoutGuideProvider {
  self = [super initWithFrame:frame];
  if (self) {
    _searchBar = [self newSearchBar]; 
    _viewBackground = [self newViewBackground];
    _exitButton = [self newExitButton];
    _tableView = [self newSearchTable];
    _layoutGuideProvider = layoutGuideProvider;
    _needsConstraints = YES;
    
    [self constructViewHierarchy];
    [self registerForKeyboardNotifications];
  }
  return self;
}


#pragma mark View Hierarchy

- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground]; 
  [self addSubview:self.searchBar];
  [self addSubview:self.exitButton];
  [self addSubview:self.tableView];
}


#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (self.needsConstraints) {
    [self.exitButton alignTrailingEdgeWithView:self predicate:@"-12"];
    [self.exitButton alignTopEdgeWithView:self.searchBar predicate:@"12"];
    [self.exitButton constrainWidth:@"28" height:@"20"];
    [self.exitButton constrainLeadingSpaceToView:self.searchBar predicate:@"7"];
    
    [self.searchBar alignLeadingEdgeWithView:self predicate:@"0"];
    NSLayoutConstraint *topLayoutConstraint =
    [NSLayoutConstraint constraintWithItem:self.searchBar
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:[self.layoutGuideProvider topLayoutGuide]
                                 attribute:NSLayoutAttributeBaseline
                                multiplier:1
                                  constant:0];
    [self addConstraint:topLayoutConstraint];
    
    [self.tableView alignLeadingEdgeWithView:self predicate:@"0"];
    [self.tableView constrainTopSpaceToView:self.searchBar predicate:@"0"];
    [self.tableView constrainWidthToView:self predicate:@"0"];
    [self.tableView alignBottomEdgeWithView:self predicate:@"0"];
    
    [self.viewBackground alignTop:@"0" leading:@"0" bottom:@"0" trailing:@"0" toView:self];
    
    self.needsConstraints = NO;
  }
}

#pragma mark Notification Observation

- (void)registerForKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Handle Keyboard

- (void)keyboardWasShown:(NSNotification*)aNotification {
  NSDictionary* info = [aNotification userInfo];
  CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
  self.tableView.contentInset = contentInsets;
  self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.tableView.contentInset = contentInsets;
  self.tableView.scrollIndicatorInsets = contentInsets;
}


#pragma mark Factory Methods

- (UIImageView *)newViewBackground{
  UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quizin_bg"]];
  [background setTranslatesAutoresizingMaskIntoConstraints:NO];
  return background;
}

- (UISearchBar *)newSearchBar{
  UISearchBar *searchBar = [[UISearchBar alloc] init];
  [searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
  [searchBar setTintColor:[UIColor colorWithWhite:.2f alpha:1.0f]];
  [searchBar setSpellCheckingType:UITextSpellCheckingTypeNo];
  for(UIView *subView in searchBar.subviews){
    if([subView isKindOfClass: [UITextField class]])
      [(UITextField *)subView setKeyboardAppearance: UIKeyboardAppearanceAlert];
    if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
      [subView removeFromSuperview];
  }
  return searchBar;
}

- (UIButton *)newExitButton {
  UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [exitButton setImage:[UIImage imageNamed:@"quizin_exit_btn"] forState:UIControlStateNormal];
  [exitButton setAlpha:0.8f];
  [exitButton setTranslatesAutoresizingMaskIntoConstraints:NO];
  return exitButton;
}

-(UITableView *)newSearchTable{
  UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                        style:UITableViewStylePlain];
  [tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [tableView setBackgroundColor:[UIColor clearColor]];
  [tableView setBackgroundView:nil];
  [tableView setOpaque:NO];
  [tableView setSeparatorColor:[UIColor grayColor]];
  [tableView setShowsVerticalScrollIndicator:NO];
  [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  tableView.rowHeight = 40;
  return tableView;
}

@end
