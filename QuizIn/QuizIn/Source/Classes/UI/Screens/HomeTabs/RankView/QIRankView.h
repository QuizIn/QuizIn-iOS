
#import <UIKit/UIKit.h>
#import "QIRankDisplayView.h"

@interface QIRankView : UIView <UIScrollViewDelegate>

@property(nonatomic,strong) NSString *rank;
@property (nonatomic, strong) QIRankDisplayView *rankDisplayView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *overlayMask;

-(void)hideRankDisplay;
@end
