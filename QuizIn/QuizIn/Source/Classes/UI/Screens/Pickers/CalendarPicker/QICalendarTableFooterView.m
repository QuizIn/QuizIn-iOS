#import "QICalendarTableFooterView.h"
#import "QIFontProvider.h"

@interface QICalendarTableFooterView ()

@property (nonatomic,strong) UIView *footerBackgroundView;
@property (nonatomic,strong) UIActivityIndicatorView *loadingIndicator; 
@property (nonatomic,strong) NSMutableArray *footerViewConstraints;

@end

@implementation QICalendarTableFooterView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _loadingIndicator = [self newLoadingIndicator];
    [self constructViewHierarchy];
  }
  return self;
}

#pragma mark View Hierarchy
-(void)constructViewHierarchy{
  [self addSubview:self.loadingIndicator];
}

#pragma mark Layout

-(void)layoutSubviews{
  [super layoutSubviews];
}

-(void)updateConstraints{
  [super updateConstraints];
  if (!self.footerViewConstraints) {

    //Constrain Views
    NSDictionary *views = NSDictionaryOfVariableBindings(_loadingIndicator);
    
    NSArray *vLoadingConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-2-[_loadingIndicator(==20)]-2-|"
                                            options:0
                                            metrics:nil
                                              views:views];

    NSLayoutConstraint *centerXLoadingIndicator = [NSLayoutConstraint constraintWithItem:_loadingIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    self.footerViewConstraints = [NSMutableArray array];
    [self.footerViewConstraints addObjectsFromArray:@[centerXLoadingIndicator]];
    [self.footerViewConstraints addObjectsFromArray:vLoadingConstraints];
    
    [self addConstraints:self.footerViewConstraints];

  }
}

#pragma mark Factory Methods
-(UIActivityIndicatorView *) newLoadingIndicator{
  UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [loadingIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
  [loadingIndicator startAnimating];
  return loadingIndicator; 
}

@end

