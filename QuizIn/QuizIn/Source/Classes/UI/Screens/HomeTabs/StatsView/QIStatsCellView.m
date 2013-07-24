
#import "QIStatsCellView.h"
#import "QIFontProvider.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface QIStatsCellView ()

@property (nonatomic,strong) UILabel *connectionNameLabel;
@property (nonatomic,strong) UILabel *knowledgeIndexLabel;
@property (nonatomic,strong) AsyncImageView *profileImageView;

@property (nonatomic,strong) NSMutableArray *cellViewConstraints;

@end

@implementation QIStatsCellView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      _connectionNameLabel = [self newConnectionNameLabel];
      _knowledgeIndexLabel = [self newKnowledgeIndexLabel];
      _profileImageView = [self newProfileImageView];
      
      [self constructViewHierarchy];
    }
    return self;
}

#pragma properties

- (void)setConnectionName:(NSString *)connectionName{
  if ([self.connectionName isEqualToString:connectionName]){
    return;
  }
  _connectionName = connectionName;
  [self updateConnectionNameLabel];
}

- (void)setKnowledgeIndex:(NSString *)knowledgeIndex{
  if([self.knowledgeIndex isEqualToString:knowledgeIndex]){
    return;
  }
  _knowledgeIndex = knowledgeIndex;
  [self updateKnowledgeIndexLabel];
}

- (void)setProfileImageURL:(NSURL *)profileImageURL{
  _profileImageURL = profileImageURL;
  [self updateProfileImage];
}

#pragma mark View Hierarchy
- (void)constructViewHierarchy {
  [self.contentView addSubview:self.connectionNameLabel];
  [self.contentView addSubview:self.knowledgeIndexLabel];
  [self.contentView addSubview:self.profileImageView];
}

-(void)updateProfileImage{
  [self.profileImageView setImageURL:self.profileImageURL];
}


#pragma Data Display
- (void)updateConnectionNameLabel{
  self.connectionNameLabel.text = self.connectionName;
}

-(void)updateKnowledgeIndexLabel{
  self.knowledgeIndexLabel.text = self.knowledgeIndex;
}

#pragma mark Layout
- (void)layoutSubviews {
  [super layoutSubviews];
}

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.cellViewConstraints) {
    
     self.cellViewConstraints = [NSMutableArray array];
    
    //Constrain CellView
    NSDictionary *cellViews = NSDictionaryOfVariableBindings(_connectionNameLabel,_knowledgeIndexLabel,_profileImageView);
    
    NSArray *hCellViewsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-[_profileImageView(==40)]-[_connectionNameLabel(==100)]-[_knowledgeIndexLabel(==40)]"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:cellViews];
    NSArray *vImageViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_profileImageView]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_connectionNameLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vKnowledgeConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_knowledgeIndexLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    
   
    
    [self.cellViewConstraints addObjectsFromArray:hCellViewsConstraints];
    [self.cellViewConstraints addObjectsFromArray:vImageViewConstraints];
    [self.cellViewConstraints addObjectsFromArray:vNameConstraints];
    [self.cellViewConstraints addObjectsFromArray:vKnowledgeConstraints];
    
    [self.contentView addConstraints:self.cellViewConstraints];
  }
}

#pragma mark Factory Methods

-(UILabel *)newConnectionNameLabel{
  UILabel *title = [[UILabel alloc] init];
  title.textAlignment = NSTextAlignmentLeft;
  title.backgroundColor = [UIColor clearColor];
  title.font = [QIFontProvider fontWithSize:10.0f style:Bold];
  title.adjustsFontSizeToFitWidth = YES;
  title.textColor = [UIColor colorWithWhite:0.33f alpha:1.0f];
  [title setTranslatesAutoresizingMaskIntoConstraints:NO];
  return title;
}

-(UILabel *)newKnowledgeIndexLabel{
  UILabel *more= [[UILabel alloc] init];
  more.textAlignment = NSTextAlignmentLeft;
  more.numberOfLines = 2;
  more.backgroundColor = [UIColor clearColor];
  more.font = [QIFontProvider fontWithSize:7.0f style:Bold];
  more.adjustsFontSizeToFitWidth = YES;
  more.textColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
  [more setTranslatesAutoresizingMaskIntoConstraints:NO];
  return more;
}

- (AsyncImageView *)newProfileImageView{
  AsyncImageView *profileImageView = [[AsyncImageView alloc] init];
  profileImageView.layer.cornerRadius = 4.0f;
  profileImageView.clipsToBounds = YES;
  [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
  profileImageView.contentMode = UIViewContentModeScaleAspectFit;
  profileImageView.showActivityIndicator = YES;
  profileImageView.crossfadeDuration = 0.3f;
  profileImageView.crossfadeImages = YES;
  return profileImageView;
}
       
@end
