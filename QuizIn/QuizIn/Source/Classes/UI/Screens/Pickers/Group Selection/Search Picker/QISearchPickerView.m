
#import "QISearchPickerView.h"

@interface QISearchPickerView ()

@property (nonatomic, strong) UIImageView *viewBackground;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation QISearchPickerView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _searchBar = [self newSearchBar]; 
      _viewBackground = [self newViewBackground];
      _exitButton = [self newExitButton];
      
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground]; 
  [self addSubview:self.searchBar];
  [self addSubview:self.exitButton]; 
}


#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraints) {
    NSDictionary *constraintViews = NSDictionaryOfVariableBindings(_searchBar, _viewBackground,_tableView,_exitButton);
    
    NSArray *hBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
    NSArray *vBackgroundContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_viewBackground]|"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
    NSArray *hBarContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBar]-7-[_exitButton(==28)]-12-|"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
    NSArray *vBarContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchBar(==44)][_tableView]|"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
    NSArray *vButtonContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-12-[_exitButton(==20)]"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
    NSArray *hTableContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
    
    self.constraints = [NSMutableArray array];
    [self.constraints addObjectsFromArray:hBackgroundContraints];
    [self.constraints addObjectsFromArray:vBackgroundContraints];
    [self.constraints addObjectsFromArray:hBarContraints];
    [self.constraints addObjectsFromArray:vBarContraints];
    [self.constraints addObjectsFromArray:vButtonContraints];
    [self.constraints addObjectsFromArray:hTableContraints];
    [self addConstraints:self.constraints];
  }
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

@end
