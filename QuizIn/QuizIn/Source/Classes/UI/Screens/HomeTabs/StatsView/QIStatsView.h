
#import <UIKit/UIKit.h>

@interface QIStatsView : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,assign) int currentRank;
@property (nonatomic,assign) int totalCorrectAnswers;
@property (nonatomic,assign) int totalIncorrectAnswers;
@property (nonatomic,strong) NSArray *connectionStats;

@property (nonatomic,strong,readwrite) UIButton *resetStatsButton;
@property (nonatomic,strong,readwrite) UIButton *printStatsButton;

@end
