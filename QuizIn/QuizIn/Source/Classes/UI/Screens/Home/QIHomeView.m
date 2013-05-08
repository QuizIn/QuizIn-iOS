#import "QIHomeView.h"

@interface QIHomeView ()

//Connections Quiz Start Area

@property(nonatomic, strong) UIView *connectionsQuizStartView;
@property(nonatomic, strong) UIImageView *connectionsQuizPaperImage;
@property(nonatomic, strong) UIImageView *connectionsQuizBinderImage;
@property(nonatomic, strong) UILabel *connectionsQuizTitle;
@property(nonatomic, strong) UILabel *connectionsQuizNumberOfConnectionsLabel;
@property(nonatomic, strong) UIView *connectionsQuizImagePreviewCollection;
@property(nonatomic, strong, readwrite) UIButton *connectionsQuizButton;

//constraints
@property(nonatomic, strong) NSMutableArray *constraintsForTopLevelViews;
@property(nonatomic, strong) NSMutableArray *constraintsForConnectionsQuizStartView;


@end

@implementation QIHomeView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    
    //Connections Quiz Start Area Init
    
    _connectionsQuizPaperImage = [self newConnectionsQuizPaperImage];
    _connectionsQuizBinderImage = [self newConnectionsQuizBinderImage];
    _connectionsQuizTitle = [self newConnectionsQuizTitle];
    _connectionsQuizNumberOfConnectionsLabel = [self newConnectionsQuizNumberOfConnectionsLabel];
    _connectionsQuizImagePreviewCollection = [self newConnectionsQuizImagePreviewCollection];
    _connectionsQuizButton = [self newConnectionsQuizButton];
    _connectionsQuizStartView = [self newConnectionsQuizStartView];
    
    [self constructViewHierachy];
  }
  return self;
}

- (void)constructViewHierachy {
  
  // Construct Connections Quiz Start Area
  [self.connectionsQuizStartView addSubview:self.connectionsQuizPaperImage];
  //[self.connectionsQuizStartView addSubview:self.connectionsQuizBinderImage];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizTitle];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizNumberOfConnectionsLabel];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizImagePreviewCollection];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizButton];
  [self addSubview:self.connectionsQuizStartView];
}

#pragma mark Layout
- (void)updateConstraints {
  [super updateConstraints];
  if (!self.constraintsForConnectionsQuizStartView) {
    
    //TopLevelView Constraints
    NSDictionary *topLevelViews = NSDictionaryOfVariableBindings(_connectionsQuizStartView);
    
    NSArray *hConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[_connectionsQuizStartView]-25-|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:topLevelViews];
    NSArray *vConstraintsTopLevelViews =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[_connectionsQuizStartView(==250)]-|"
                                            options:NSLayoutFormatAlignAllBaseline
                                            metrics:nil
                                              views:topLevelViews];
    
    self.constraintsForTopLevelViews = [NSMutableArray array];
    [self.constraintsForTopLevelViews  addObjectsFromArray:hConstraintsTopLevelViews];
    [self.constraintsForTopLevelViews  addObjectsFromArray:vConstraintsTopLevelViews];
    [self addConstraints:self.constraintsForTopLevelViews];
    
    
    
    //ConnectionsQuizStartView Constraints
    
    NSDictionary *connectionQuizViews = NSDictionaryOfVariableBindings(_connectionsQuizPaperImage,_connectionsQuizBinderImage,_connectionsQuizTitle,_connectionsQuizNumberOfConnectionsLabel,_connectionsQuizImagePreviewCollection,_connectionsQuizButton);
    NSString *primaryVertical = @"V:|-[_connectionsQuizPaperImage]-[_connectionsQuizTitle]-[_connectionsQuizNumberOfConnectionsLabel]-[_connectionsQuizImagePreviewCollection(==30)]-[_connectionsQuizButton]-|";
    
    NSArray *vConstraintsConnectionsQuizViews =
    [NSLayoutConstraint constraintsWithVisualFormat:primaryVertical
                                            options:NSLayoutFormatAlignAllLeft
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsPaperImage =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizPaperImage]-|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsTitle =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizTitle]-|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsConnectionsLabel =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizNumberOfConnectionsLabel]-|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsImagePreview =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizImagePreviewCollection]-|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];
    
    NSArray *hConstraintsConnectionsQuizViewsQuizButton =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_connectionsQuizButton]-|"
                                            options:0
                                            metrics:nil
                                              views:connectionQuizViews];

    self.constraintsForConnectionsQuizStartView = [NSMutableArray array];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsPaperImage];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsTitle];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsConnectionsLabel];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsImagePreview];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:hConstraintsConnectionsQuizViewsQuizButton];
    [self.constraintsForConnectionsQuizStartView  addObjectsFromArray:vConstraintsConnectionsQuizViews];
    [_connectionsQuizStartView addConstraints:self.constraintsForConnectionsQuizStartView];
    
    //[self.constraints addObjectsFromArray:@[cn,cn2]];
    
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];
  // TODO(rcacheaux): Use autolayout.
  
  CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
  
  float leftPadding = 25.0f;
  float topPadding = 30.0f;
  //self.connectionsQuizStartView.frame = CGRectMake(0.0f, 10.0f, 320.0f, 200.0f);
  //self.connectionsQuizPaperImage.frame = CGRectMake(0.0f, 10.0f, 320.0f, 200.0f);
  //self.connectionsQuizTitle.frame = CGRectMake(leftPadding, topPadding, 280.0f, 20.0f);
  //self.connectionsQuizNumberOfConnectionsLabel.frame = CGRectMake(leftPadding, topPadding+20.0f, 280.0f, 20.0f);
  //self.connectionsQuizImagePreviewCollection.frame = CGRectMake(leftPadding+10.0f, topPadding+60.0f, 250.0f, 60.0f);
  //self.connectionsQuizButton.frame = CGRectMake(leftPadding+100, topPadding+130.0f, 150.0f, 52.0f);

}

#pragma mark Factory Methods

// Setup Connections Quiz Start Area

- (UIImageView *)newConnectionsQuizPaperImage{
  UIImageView *paperImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_paperstack"]];
  [paperImage setTranslatesAutoresizingMaskIntoConstraints:NO];
  return paperImage;
}
- (UIImageView *)newConnectionsQuizBinderImage{
  UIImageView *binderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"connectionsquiz_paperstack"]];
  [binderImage setTranslatesAutoresizingMaskIntoConstraints:NO];
  return binderImage;
}
- (UILabel *)newConnectionsQuizTitle{
  UILabel *quizTitle = [[UILabel alloc] init];
  quizTitle.text = @"Connections Quiz";
  quizTitle.backgroundColor = [UIColor clearColor];
  [quizTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizTitle;
}
- (UILabel *)newConnectionsQuizNumberOfConnectionsLabel{
  UILabel *quizConnections = [[UILabel alloc] init];
  quizConnections.text = @"865 Connections";
  quizConnections.backgroundColor = [UIColor clearColor];
  quizConnections.textColor = [UIColor grayColor];
  [quizConnections setTranslatesAutoresizingMaskIntoConstraints:NO];
  return quizConnections;
}
- (UIView *)newConnectionsQuizImagePreviewCollection{
  UIView *previewArea = [[UIView alloc] init];
  previewArea.backgroundColor = [UIColor grayColor];
  [previewArea setTranslatesAutoresizingMaskIntoConstraints:NO];
  return previewArea;
}
- (UIButton *)newConnectionsQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:[self connectionsQuizButtonTitle] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"connectionsquiz_takequiz_btn"] forState:UIControlStateNormal];
  [button setTranslatesAutoresizingMaskIntoConstraints:NO];
  button.backgroundColor = [UIColor clearColor];
  return button;
}
- (UIView *)newConnectionsQuizStartView{
  UIView *startView = [[UIView alloc] init];
  startView.backgroundColor = [UIColor lightGrayColor];
  [startView setTranslatesAutoresizingMaskIntoConstraints:NO];
  return startView;
}

#pragma mark Strings

- (NSString *)connectionsQuizButtonTitle {
  return @"Take Quiz";
}

@end
