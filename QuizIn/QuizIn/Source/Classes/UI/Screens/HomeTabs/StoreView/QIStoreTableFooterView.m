
#import "QIStoreTableFooterView.h"
#import "QIFontProvider.h"

@interface QIStoreTableFooterView ()

@property (nonatomic, strong) NSMutableArray *footerViewConstraints; 

@end


@implementation QIStoreTableFooterView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _restoreButton = [self newRestoreButton];
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark View Hierarchy
- (void) constructViewHierarchy{
  [self addSubview:self.restoreButton];
}

#pragma mark Layout
-(void)layoutSubviews{
  [super layoutSubviews];
}

-(void)updateConstraints{
  [super updateConstraints];
  if (!self.footerViewConstraints) {

    NSDictionary *views = NSDictionaryOfVariableBindings(_restoreButton);
    
    NSArray *hButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|[_restoreButton]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vButtonConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_restoreButton(==40)]"
                                            options:0
                                            metrics:nil
                                              views:views];

    self.footerViewConstraints = [NSMutableArray array];
    [self.footerViewConstraints addObjectsFromArray:hButtonConstraints];
    [self.footerViewConstraints addObjectsFromArray:vButtonConstraints];
    [self addConstraints:self.footerViewConstraints]; 

  }
}


#pragma mark Factory Methods
- (UIButton *)newRestoreButton{
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self restoreButtonTitleString] forState:UIControlStateNormal];
  [button.titleLabel setFont:[QIFontProvider fontWithSize:14.0f style:Regular]];
  [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
  [button setTitleColor:[UIColor colorWithWhite:.33f alpha:1.0f] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor colorWithWhite:0.0f alpha:1.0f] forState:UIControlStateHighlighted];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  [button setBackgroundColor:[UIColor clearColor]];
  return button;
}

#pragma mark Strings
- (NSString *)restoreButtonTitleString{
  return @"Restore My Purchases"; 
}
@end
