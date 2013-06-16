

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
-(void)loadView{
  self.view = [[QICalendarPickerView alloc] init];

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.calendarPickerView.backgroundColor = [UIColor whiteColor];
  self.calendarPickerView.calendarContent = [NSMutableArray arrayWithObjects:@"Meeting",@"AnotherMeeting",@"A Crazy Meeting", @"More meetings", nil];
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
