
#import "QIStoreCellView.h"
#import "QIFontProvider.h"

@interface QIStoreCellView ()

@property (nonatomic, strong) NSMutableArray *constraints;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation QIStoreCellView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _iconImageView = [self newIconImageView];
      _buyButton = [self newBuyButton];
      _previewButton = [self newPreviewButton];
      _descriptionLabel = [self newDescriptionLabel];
      
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark Properties

- (void)setDescriptionString:(NSString *)descriptionString{
  _descriptionString = descriptionString;
  [self updateDescription];
}

- (void)setIconImage:(UIImage *)image{
  _iconImage = image;
  [self updateIconImage]; 
}

- (void) setPurchased:(BOOL)purchased{
  _purchased = purchased;
  [self updateCellForPurchasedState];
}

#pragma mark Layout
- (void)constructViewHierarchy{
  [self.contentView addSubview:_iconImageView];
  [self.contentView addSubview:_previewButton];
  [self.contentView addSubview:_buyButton];
  [self.contentView addSubview:_descriptionLabel];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraints){
    self.constraints = [NSMutableArray array];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_previewButton,_buyButton,_descriptionLabel,_iconImageView);
    
    NSArray *hBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-41-[_iconImageView(==238)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_iconImageView(==60)]"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:views];
    
    NSArray *vBuyButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_iconImageView]-5-[_buyButton(==22)]"
                                            options:NSLayoutFormatAlignAllRight
                                            metrics:nil
                                              views:views];
    NSArray *hButtons =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_previewButton(==78)]-5-[_buyButton(==_previewButton)]"
                                            options:NSLayoutFormatAlignAllBottom
                                            metrics:nil
                                              views:views];
    
    NSArray *hDescriptionLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_iconImageView]-(-175)-[_descriptionLabel(==165)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vDescriptionLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[_descriptionLabel(==40)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    

  
    [self.constraints addObjectsFromArray:hBackground];
    [self.constraints addObjectsFromArray:vBackground];
    [self.constraints addObjectsFromArray:hButtons];
    [self.constraints addObjectsFromArray:vBuyButton];
    [self.constraints addObjectsFromArray:vDescriptionLabel];
    [self.constraints addObjectsFromArray:hDescriptionLabel];
    
    [self.contentView addConstraints:self.constraints];
  }
}

#pragma mark Data Layout

- (void)updateDescription{
  self.descriptionLabel.text = self.descriptionString;
}

- (void)updateIconImage{
  [self.iconImageView setImage:self.iconImage forState:UIControlStateNormal];
}

- (void)updateCellForPurchasedState{
  [self.previewButton setHidden:self.purchased];
  [self.buyButton setHidden:self.purchased];
}

#pragma mark Factory Methods
- (UIImageView *)newBackgroundImage{
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_productcard"]];
  [image setContentMode:UIViewContentModeCenter];
  [image setTranslatesAutoresizingMaskIntoConstraints:NO];
  return image;
}

- (UIButton *)newIconImageView{
  UIButton *button = [[UIButton alloc] init];
  [button setAdjustsImageWhenHighlighted:YES];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

- (UIButton *)newPreviewButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"store_preview_btn"] forState:UIControlStateNormal];
   [button setAdjustsImageWhenHighlighted:YES];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

- (UIButton *)newBuyButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"store_purchase_btn"] forState:UIControlStateNormal];
  [button setAdjustsImageWhenHighlighted:YES];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

-(UILabel *)newDescriptionLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor colorWithWhite:.3f alpha:1.0f]];
  [label setNumberOfLines:2];
  [label setFont:[QIFontProvider fontWithSize:11.0f style:Regular]];
  return label;
}

@end
