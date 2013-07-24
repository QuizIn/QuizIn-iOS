
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface QIGroupSelectionView : UIView <UITableViewDataSource, UIGestureRecognizerDelegate,
UIScrollViewDelegate,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *selectionContent;
@property (nonatomic, strong) NSString *selectionViewLabelString;
@property (nonatomic, strong, readonly) UIButton *quizButton;
@property (nonatomic, strong, readonly) UIButton *backButton; 

@end
