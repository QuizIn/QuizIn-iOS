#import "QIGroupSelectionTableFooterView.h"
#import "QIFontProvider.h"

@interface QIGroupSelectionTableFooterView ()

@property (nonatomic, strong) NSMutableArray *footerViewConstraints;

@end

@implementation QIGroupSelectionTableFooterView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _searchButton = [self newSearchButton];
    _searchBar = [self newSearchBar];
    
    [self setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f]];
    [self constructViewHierarchy];
  }
  return self;
}

#pragma mark View Hierarchy
-(void)constructViewHierarchy{
  [self addSubview:self.searchBar];
  [self addSubview:self.searchButton];
}

#pragma mark Layout

-(void)layoutSubviews{
  [super layoutSubviews];
}

-(void)updateConstraints{
  [super updateConstraints];
  if (!self.footerViewConstraints) {

    //Constrain Views
    NSDictionary *views = NSDictionaryOfVariableBindings(_searchBar, _searchButton);
    
    NSArray *hBarConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_searchButton]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vBarConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_searchButton(==44)]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *hButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_searchBar]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_searchBar(==44)]|"
                                            options:0
                                            metrics:nil
                                              views:views];

    
    self.footerViewConstraints = [NSMutableArray array];
    [self.footerViewConstraints addObjectsFromArray:hBarConstraints];
    [self.footerViewConstraints addObjectsFromArray:vBarConstraints];
    [self.footerViewConstraints addObjectsFromArray:hButtonConstraints];
    [self.footerViewConstraints addObjectsFromArray:vButtonConstraints];
    
    [self addConstraints:self.footerViewConstraints];
  }
}

#pragma mark Factory Methods

- (UIButton *)newSearchButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setShowsTouchWhenHighlighted:NO]; 
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  button.backgroundColor = [UIColor clearColor];
  return button;
}

- (UISearchBar *)newSearchBar{
  UISearchBar *searchBar = [[UISearchBar alloc] init];
  [searchBar setShowsCancelButton:NO animated:YES];
  [searchBar setTranslatesAutoresizingMaskIntoConstraints:NO];
  [searchBar setTintColor:[UIColor clearColor]];
  [searchBar setPlaceholder:@"Search For More"];
  for (UIView *subview in searchBar.subviews) {
    if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
      [subview removeFromSuperview];
      break;
    }
  }
  return searchBar;
}

@end

