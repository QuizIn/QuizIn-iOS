#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface QIHomeView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIButton *connectionsQuizButton;

@property (nonatomic, strong, readonly) UIButton *companyQuizLockButton;
@property (nonatomic, strong, readonly) UIButton *localeQuizLockButton;
@property (nonatomic, strong, readonly) UIButton *industryQuizLockButton;
@property (nonatomic, strong, readonly) UIButton *groupQuizLockButton;

@property (nonatomic, strong, readonly) UIButton *companyQuizBeginButton;
@property (nonatomic, strong, readonly) UIButton *localeQuizBeginButton;
@property (nonatomic, strong, readonly) UIButton *industryQuizBeginButton;
@property (nonatomic, strong, readonly) UIButton *groupQuizBeginButton;

//todo rkuhlman fix
@property (nonatomic, strong, readonly) UIButton *testButton;
@property (nonatomic, strong, readonly) UIButton *testButton1; 

@property (nonatomic, strong) UIScrollView *scrollView; 
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, assign) NSInteger numberOfConnections;

@end
