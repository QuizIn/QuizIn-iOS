
#import <UIKit/UIKit.h>
#import "QIRankDisplayView.h"

@interface QIRankView : UIView

@property(nonatomic,strong) NSString *rank;
@property (nonatomic, strong) QIRankDisplayView *rankDisplayView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) UIScrollView *scrollView;

-(void)hideRankDisplay;
@end
