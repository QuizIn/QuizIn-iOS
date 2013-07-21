#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface QIHomeView : UIView

@property(nonatomic, strong, readonly) UIButton *connectionsQuizButton;

//temporary Buttons
@property(nonatomic, strong, readonly) UIButton *calendarPickerButton;
@property(nonatomic, strong, readonly) UIButton *businessCardQuizButton;
@property(nonatomic, strong, readonly) UIButton *matchingQuizButton;
@property(nonatomic, strong, readonly) UIButton *statsViewButton;
@property(nonatomic, strong, readonly) UIButton *showStatsButton;

@end
