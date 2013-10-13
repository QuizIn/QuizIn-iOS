
#import <UIKit/UIKit.h>

@interface QIStatsSectionHeaderView : UIView

@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, strong) UIButton *alphaHeader;
@property (nonatomic, strong) UIButton *correctHeader;
@property (nonatomic, strong) UIButton *incorrectHeader;
@property (nonatomic, strong) UIButton *trendHeader;
@property (nonatomic, strong) UIButton *knownHeader;
@property (nonatomic, assign) NSInteger selectedSorter; 
@end
