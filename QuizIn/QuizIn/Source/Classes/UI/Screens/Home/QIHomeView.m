#import "QIHomeView.h"

@interface QIHomeView ()

//Connections Quiz Start Area

@property(nonatomic, strong) UIView *connectionsQuizStartView;
@property(nonatomic, strong) UIImageView *connectionsQuizPaperImage;
@property(nonatomic, strong) UIImageView *connectionsQuizBinderImage;
@property(nonatomic, strong) UILabel *connectionsQuizTitle;
@property(nonatomic, strong) UILabel *connectionsQuizNumberOfConnectionsLabel;
@property(nonatomic, strong) UIView *connectionsQuizImagePreviewCollection;
@property(nonatomic, strong) UIButton *connectionsQuizButton;

@end

@implementation QIHomeView

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
  [self.connectionsQuizStartView addSubview:self.connectionsQuizBinderImage];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizTitle];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizNumberOfConnectionsLabel];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizImagePreviewCollection];
  [self.connectionsQuizStartView addSubview:self.connectionsQuizButton];
  [self addSubview:self.connectionsQuizStartView];
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  // TODO(rcacheaux): Use autolayout.
  CGPoint centerPoint = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
  self.connectionsQuizStartView.frame = CGRectMake(20.0f, 20.0f, 280.0f, 200.0f);
  self.connectionsQuizTitle.frame = CGRectMake(0.0f, 0.0f, 280.0f, 20.0f);
  self.connectionsQuizNumberOfConnectionsLabel.frame = CGRectMake(0.0f, 20.0f, 280.0f, 40.0f);
  self.connectionsQuizImagePreviewCollection.frame = CGRectMake(20.0f, 40.0f, 240.0f, 80.0f);
  self.connectionsQuizButton.frame = CGRectMake(0.0f, 80.0f, 80.0f, 40.0f);
  //self.connectionsQuizButton.bounds = CGRectMake(0.0f, 0.0f, 80.0f, 44.0f);
}

#pragma mark Factory Methods

// Setup Connections Quiz Start Area

- (UIImageView *)newConnectionsQuizPaperImage{
  UIImageView *paperImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
  return paperImage;
}
- (UIImageView *)newConnectionsQuizBinderImage{
  UIImageView *binderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default"]];
  return binderImage;
}
- (UILabel *)newConnectionsQuizTitle{
  UILabel *quizTitle = [[UILabel alloc] init];
  quizTitle.text = @"Connections Quiz";
  return quizTitle;
}
- (UILabel *)newConnectionsQuizNumberOfConnectionsLabel{
  UILabel *quizConnections = [[UILabel alloc] init];
  quizConnections.text = @"<number of Connections> Connections";
  return quizConnections;
}
- (UIView *)newConnectionsQuizImagePreviewCollection{
  UIView *previewArea = [[UIView alloc] init];
  previewArea.backgroundColor = [UIColor grayColor];
  return previewArea;
}
- (UIButton *)newConnectionsQuizButton {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:[self connectionsQuizButtonTitle] forState:UIControlStateNormal];
  return button;
}
- (UIView *)newConnectionsQuizStartView{
  UIView *startView = [[UIView alloc] init];
  startView.backgroundColor = [UIColor clearColor];
  startView.clipsToBounds = YES;
  return startView;
}

#pragma mark Strings

- (NSString *)connectionsQuizButtonTitle {
  return @"Take Quiz";
}

@end
