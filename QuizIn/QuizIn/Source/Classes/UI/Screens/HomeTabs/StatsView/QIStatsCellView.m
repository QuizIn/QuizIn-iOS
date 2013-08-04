
#import "QIStatsCellView.h"
#import "QIFontProvider.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface QIStatsCellView ()

@property (nonatomic,strong) UILabel *connectionNameLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UILabel *wrongLabel;
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
      _rightLabel = [self newKnowledgeIndexLabel];
      _wrongLabel = [self newKnowledgeIndexLabel];
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
- (void)setRightAnswers:(NSString *)rightAnswers{
  _rightAnswers = rightAnswers;
  [self updateRightAnswers];
}
-(void)setWrongAnswers:(NSString *)wrongAnswers{
  _wrongAnswers = wrongAnswers;
  [self updateWrongAnswers];
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
  [self.contentView addSubview:self.rightLabel];
  [self.contentView addSubview:self.wrongLabel];
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

-(void)updateRightAnswers{
  self.rightLabel.text = self.rightAnswers;
}

-(void)updateWrongAnswers{
  self.wrongLabel.text = self.wrongAnswers; 
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
    NSDictionary *cellViews = NSDictionaryOfVariableBindings(_connectionNameLabel,_knowledgeIndexLabel,_profileImageView,_rightLabel,_wrongLabel);
    
    NSArray *hCellViewsConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"H:|-3-[_profileImageView(==40)]-3-[_connectionNameLabel(==100)]-(>=10)-[_rightLabel(==40)][_wrongLabel(==40)][_knowledgeIndexLabel(==40)]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vImageViewConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|-3-[_profileImageView]-3-|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vNameConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_connectionNameLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vRightConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_rightLabel]|"
                                            options:0
                                            metrics:nil
                                              views:cellViews];
    NSArray *vWrongConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:  @"V:|[_wrongLabel]|"
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
    [self.cellViewConstraints addObjectsFromArray:vRightConstraints];
    [self.cellViewConstraints addObjectsFromArray:vWrongConstraints];
    
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
  more.backgroundColor = [UIColor clearColor];
  more.font = [QIFontProvider fontWithSize:10.0f style:Bold];
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
