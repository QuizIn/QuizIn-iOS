
#import "QIStoreCellView.h"
#import "QIFontProvider.h"

@interface QIStoreCellView ()

@property (nonatomic, strong) UIImageView *backgroundImage;

@property (nonatomic, strong) NSMutableArray *constraints;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *checkmark; 

@end


@implementation QIStoreCellView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _backgroundImage = [self newBackgroundImage];
      _buyButton = [self newBuyButton];
      _previewButton = [self newPreviewButton];
      _titleLabel = [self newTitleLabel];
      _priceLabel = [self newPriceLabel];
      _descriptionLabel = [self newDescriptionLabel];
      _iconImageView = [self newIconImageView];
      _checkmark = [self newCheckMarkImage]; 
      
      [self constructViewHierarchy]; 
    }
    return self;
}

#pragma mark Properties
- (void)setTitle:(NSString *)title{
  _title = title;
  [self updateTitle];
}

- (void)setPrice:(NSString *)price{
  _price = price;
  [self updatePrice];
}

- (void)setDescription:(NSString *)description{
  _description = description;
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
  [self.contentView addSubview:_backgroundImage];
  [self.contentView addSubview:_previewButton];
  [self.contentView addSubview:_buyButton];
  [self.contentView addSubview:_titleLabel];
  [self.contentView addSubview:_priceLabel];
  [self.contentView addSubview:_descriptionLabel];
  [self.contentView addSubview:_iconImageView];
  [self.contentView addSubview:_checkmark]; 
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (!self.constraints){
    self.constraints = [NSMutableArray array];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_backgroundImage,_previewButton,_buyButton,_titleLabel,_priceLabel,_descriptionLabel,_iconImageView,_checkmark);
    
    NSArray *hBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vBackground =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundImage]|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *hButtons =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_backgroundImage]-(-213)-[_previewButton]-8-[_buyButton]"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vPreviewButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backgroundImage]-(-41)-[_previewButton(==25)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vBuyButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_backgroundImage]-(-41)-[_buyButton(==25)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSLayoutConstraint *heightCheckmark = [NSLayoutConstraint constraintWithItem:_checkmark attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_buyButton attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *widthCheckmark = [NSLayoutConstraint constraintWithItem:_checkmark attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_buyButton attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *hCheckmark = [NSLayoutConstraint constraintWithItem:_checkmark attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_buyButton attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *vCheckmark = [NSLayoutConstraint constraintWithItem:_checkmark attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_buyButton attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    NSArray *hTitleLabels =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_titleLabel(==200)][_priceLabel]-28-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:views];
    NSLayoutConstraint *hTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_backgroundImage attribute:NSLayoutAttributeLeft multiplier:1.0f constant:28.0f];
    NSLayoutConstraint *vTitleLabel = [NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_backgroundImage attribute:NSLayoutAttributeTop multiplier:1.0f constant:11.0f];
    

    NSArray *hIconLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_iconImageView(==50)]-5-[_descriptionLabel(>=10)]-15-|"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vIconLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_iconImageView(==50)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    
    NSArray *vDescriptionLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel]-7-[_descriptionLabel(==25)]"
                                            options:0
                                            metrics:nil
                                              views:views];
    

  
    [self.constraints addObjectsFromArray:hBackground];
    [self.constraints addObjectsFromArray:vBackground];
    [self.constraints addObjectsFromArray:hButtons];
    [self.constraints addObjectsFromArray:vPreviewButton];
    [self.constraints addObjectsFromArray:vBuyButton];
    [self.constraints addObjectsFromArray:hTitleLabels];
    [self.constraints addObjectsFromArray:vDescriptionLabel];
    [self.constraints addObjectsFromArray:vIconLabel];
    [self.constraints addObjectsFromArray:hIconLabel];
    [self.constraints addObjectsFromArray:@[hTitleLabel,vTitleLabel,heightCheckmark,widthCheckmark,hCheckmark,vCheckmark]];
    
    [self.contentView addConstraints:self.constraints];
  }
}

#pragma mark Data Layout
- (void)updateTitle{
  self.titleLabel.text = self.title;
}

- (void)updatePrice{
  self.priceLabel.text = self.price;
}

- (void)updateDescription{
  self.descriptionLabel.text = self.description; 
}

- (void)updateIconImage{
  self.iconImageView.image = self.iconImage;
}

- (void)updateCellForPurchasedState{
  [self.previewButton setHidden:self.purchased];
  [self.buyButton setHidden:self.purchased];
  [self.checkmark setHidden:!self.purchased]; 
}

- (void)blinkButtons{
  [UIView
   animateWithDuration:1
   delay:0.0
   options:UIViewAnimationOptionAllowUserInteraction
   animations:^{
     self.backgroundImage.alpha = .2f;
     self.titleLabel.alpha = .2f;
     self.descriptionLabel.alpha = .2f;
     self.priceLabel.alpha = .2f;
     self.iconImageView.alpha = .2f;
                  }
   completion:^(BOOL finished){
     [UIView
      animateWithDuration:1
      delay:0.0
      options:UIViewAnimationOptionAllowUserInteraction
      animations:^{
        self.backgroundImage.alpha = 1.0f;
        self.titleLabel.alpha = 1.0f;
        self.descriptionLabel.alpha = 1.0f;
        self.priceLabel.alpha = 1.0f;
        self.iconImageView.alpha = 1.0f;      }
      completion:nil];
   }];
}

#pragma mark Actions
- (void)highlight{
  self.highlightTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(blinkButtons) userInfo:nil repeats:YES];
  [self blinkButtons]; 
}

#pragma mark Factory Methods
- (UIImageView *)newBackgroundImage{
  UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_productcard"]];
  [image setContentMode:UIViewContentModeCenter];
  [image setTranslatesAutoresizingMaskIntoConstraints:NO];
  return image;
}

- (UIImageView *)newIconImageView{
  UIImageView *image = [[UIImageView alloc] init];
  [image setBackgroundColor:[UIColor clearColor]];
  [image setContentMode:UIViewContentModeScaleAspectFit];
  [image setTranslatesAutoresizingMaskIntoConstraints:NO];
  return image;
}

- (UIButton *)newPreviewButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"store_preview_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

- (UIButton *)newBuyButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"store_purchasel_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  return button;
}

-(UIImageView *)newCheckMarkImage{
  UIImageView *check = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"calendar_checkmark"]];
  [check setContentMode:UIViewContentModeScaleAspectFit];
  [check setTranslatesAutoresizingMaskIntoConstraints:NO];
  return check;
}

-(UILabel *)newTitleLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setFont:[QIFontProvider fontWithSize:12.0f style:Bold]];
  return label;
}

-(UILabel *)newPriceLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextAlignment:NSTextAlignmentRight]; 
  [label setTextColor:[UIColor whiteColor]];
  [label setFont:[QIFontProvider fontWithSize:12.0f style:Regular]];
  return label;
}

-(UILabel *)newDescriptionLabel{
  UILabel *label = [[UILabel alloc] init];
  [label setTranslatesAutoresizingMaskIntoConstraints:NO];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor colorWithWhite:.3f alpha:1.0f]];
  [label setNumberOfLines:2];
  [label setFont:[QIFontProvider fontWithSize:10.0f style:Regular]];
  return label;
}

@end
