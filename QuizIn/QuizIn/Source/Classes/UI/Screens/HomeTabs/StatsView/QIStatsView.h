
#import "QIStatsTableHeaderView.h"
#import "QIStatsSectionHeaderView.h"
#import "QIStatsSummaryView.h"
#import "QIStatsCellView.h"
#import <UIKit/UIKit.h>

@interface QIStatsView : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) QIStatsSummaryView *summaryView;

@property (nonatomic,assign) int currentRank;
@property (nonatomic,assign) int totalCorrectAnswers;
@property (nonatomic,assign) int totalIncorrectAnswers;
@property (nonatomic,strong) NSArray *connectionStats;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic,strong,readwrite) UIButton *resetStatsButton;
@property (nonatomic,strong,readwrite) UIButton *printStatsButton;

@end
