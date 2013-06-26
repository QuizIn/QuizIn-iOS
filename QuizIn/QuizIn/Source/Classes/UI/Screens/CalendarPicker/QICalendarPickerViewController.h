
#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "QICalendarPickerView.h"
#import "QICalendarData.h"

@interface QICalendarPickerViewController : UIViewController

@property (nonatomic, strong) QICalendarPickerView *calendarPickerView;
@property (nonatomic, strong) EKEventStore *eventStore;

@end
