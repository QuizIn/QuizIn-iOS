#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface QIHomeView : UIView

@property(nonatomic, strong, readonly) UIButton *connectionsQuizButton;
@property(nonatomic, strong) NSArray *imageURLs;
@property(nonatomic, assign) NSInteger numberOfConnections;

//temporary Buttons
@property(nonatomic, strong, readonly) UIButton *calendarPickerButton;
@property(nonatomic, strong, readonly) UIButton *businessCardQuizButton;
@property(nonatomic, strong, readonly) UIButton *matchingQuizButton;

@end
