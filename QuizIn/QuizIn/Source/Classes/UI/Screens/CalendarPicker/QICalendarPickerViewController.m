

#import "QICalendarPickerViewController.h"

@interface QICalendarPickerViewController ()

@end


@implementation QICalendarPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          }
    return self;
}

-(void)setEventStore:(EKEventStore *)eventStore{
  _eventStore = self.eventStore;
}

-(void)loadView{
  //self.view = [[QICalendarPickerView alloc] init];
  self.view = [[QICalendarPickerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad{
  [super viewDidLoad];
  //self.calendarPickerView.backgroundColor = [UIColor whiteColor];
  self.calendarPickerView.eventStore = self.eventStore;
  NSMutableArray *calendarContent = [QICalendarData getCalendarDataWithIntervalIndex:0 withEventStore:self.eventStore];
  self.calendarPickerView.calendarContent = calendarContent; 
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (QICalendarPickerView *)calendarPickerView {
  return (QICalendarPickerView *)self.view;
}
@end
