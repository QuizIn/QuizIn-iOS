#import "DLPieChart.h"
#import <UIKit/UIKit.h>


@interface QIStatsSummaryView : UIView <DLPieChartDataSource, DLPieChartDelegate>

@property (nonatomic, strong) UISegmentedControl *sorterSegmentedControl;
@property (nonatomic, strong) NSMutableArray *pieChartData;
@property (nonatomic, retain) DLPieChart *pieChartView;
@property (nonatomic, strong) UIButton *leastQuizButton;
@property (nonatomic, strong) UIButton *leastQuizLockButton;
@property (nonatomic, strong) NSNumber *correctAnswers;
@property (nonatomic, strong) NSNumber *incorrectAnswers;
@property (nonatomic, strong) NSNumber *currentRank;

- (void)drawPieChart;

@end
