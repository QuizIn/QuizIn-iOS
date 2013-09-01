#import "DLPieChart.h"
#import <UIKit/UIKit.h>


@interface QIStatsSummaryView : UIView <DLPieChartDataSource, DLPieChartDelegate>

@property (nonatomic, strong) UISegmentedControl *sorterSegmentedControl;
@property (nonatomic, strong) NSMutableArray *pieChartData; 

@end
