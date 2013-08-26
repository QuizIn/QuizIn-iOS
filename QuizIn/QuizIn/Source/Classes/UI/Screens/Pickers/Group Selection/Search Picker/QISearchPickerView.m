
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
      
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy{
  [self addSubview:self.viewBackground]; 
  [self addSubview:self.searchBar]; 
}


#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraints) {
    NSDictionary *constraintViews = NSDictionaryOfVariableBindings(_searchBar, _viewBackground);
    
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
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_searchBar]|"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
    NSArray *vBarContraints =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_searchBar(==44)]"
                                            options:0
                                            metrics:nil
                                              views:constraintViews];
        
    self.constraints = [NSMutableArray array];
    [self.constraints addObjectsFromArray:hBackgroundContraints];
    [self.constraints addObjectsFromArray:vBackgroundContraints];
    [self.constraints addObjectsFromArray:hBarContraints];
    [self.constraints addObjectsFromArray:vBarContraints];
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
  [searchBar setShowsCancelButton:YES animated:YES];
  [searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
  [searchBar setTintColor:[UIColor colorWithWhite:.2f alpha:1.0f]];
  for(UIView *subView in searchBar.subviews){
    if([subView isKindOfClass: [UITextField class]])
      [(UITextField *)subView setKeyboardAppearance: UIKeyboardAppearanceAlert];
    if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
      [subView removeFromSuperview];
  }
  return searchBar;
}
@end
