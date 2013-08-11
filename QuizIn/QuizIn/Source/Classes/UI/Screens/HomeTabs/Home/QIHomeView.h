#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface QIHomeView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIButton *connectionsQuizButton;
@property (nonatomic, strong, readonly) UIButton *companyQuizButton;
@property (nonatomic, strong, readonly) UIButton *localeQuizButton;
@property (nonatomic, strong, readonly) UIButton *industryQuizButton;
@property (nonatomic, strong, readonly) UIButton *groupQuizButton;
@property (nonatomic, strong) UIScrollView *scrollView; 
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, assign) NSInteger numberOfConnections;

@end
