#import "DLPieChart.h"
#import <UIKit/UIKit.h>


@interface QIStatsSummaryView : UIView <DLPieChartDataSource, DLPieChartDelegate>

@property (nonatomic, strong) UISegmentedControl *sorterSegmentedControl;
@property (nonatomic, strong) NSMutableArray *pieChartData;
@property (nonatomic, retain) DLPieChart *pieChartView;
@property (nonatomic, strong) UIButton *leastQuizButton;
@property (nonatomic, strong) NSString *correctAnswers;
@property (nonatomic, strong) NSString *incorrectAnswers;
@property (nonatomic, strong) NSString *currentRank;


@end
