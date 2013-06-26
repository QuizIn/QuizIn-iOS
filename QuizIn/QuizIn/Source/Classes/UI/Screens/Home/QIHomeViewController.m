#import "QIHomeViewController.h"

#import "QIHomeView.h"
#import "QIQuizViewController.h"
#import "QICalendarPickerViewController.h"

@interface QIHomeViewController ()
@property(nonatomic, strong, readonly) QIHomeView *homeView;
@end

@implementation QIHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self loadNavigation];
  }
  return self;
}

- (void)loadNavigation {
  self.title = [self homeScreenTitle];
}

- (void)loadView {
  self.view = [[QIHomeView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.homeView.connectionsQuizButton addTarget:self
                                          action:@selector(startConnectionsQuiz:)
                                forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.calendarPickerButton addTarget:self
                                         action:@selector(calendarPicker:)
                               forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions

- (void)startConnectionsQuiz:(id)sender {
  QIQuizViewController *quizViewController = [self newQuizViewController];
  [self presentViewController:quizViewController animated:YES completion:nil];
}

- (void)calendarPicker:(id)sender {
  EKEventStore *store = [[EKEventStore alloc] init];
  EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
  BOOL needsToRequestAccessToEventStore = (authorizationStatus == (EKAuthorizationStatusNotDetermined | EKAuthorizationStatusDenied));
  
  if (needsToRequestAccessToEventStore) {
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
      if (granted) {
        NSLog(@"ACCESS");
        [self performSelectorOnMainThread:
         @selector(calendarViewControllerWithEventStore:)
                               withObject:store
                            waitUntilDone:NO];
      } else {
        NSLog(@"ACCESS DENIED");
        // Remove
        [self performSelectorOnMainThread:
         @selector(calendarViewControllerWithEventStore:)
                               withObject:store
                            waitUntilDone:NO];
      }
    }];
  } else {
    BOOL granted = (authorizationStatus == EKAuthorizationStatusAuthorized);
    if (granted) {
      NSLog(@"Already had ACCESS");
      [self calendarViewControllerWithEventStore:store];
    } else {
      NSLog(@"ACCESS DENIED PREVIOUSLY");
      [self calendarViewControllerWithEventStore:store];
    }
  }
}

- (void)calendarViewControllerWithEventStore:(EKEventStore *)store{
  QICalendarPickerViewController *calendarPickerViewController = [self newCalendarPickerViewController];
  calendarPickerViewController.eventStore = store; 
  [self presentViewController:calendarPickerViewController animated:YES completion:nil];
}
#pragma mark Strings

- (NSString *)homeScreenTitle {
  return @"Quizin";
}
   
#pragma mark Properties

- (QIHomeView *)homeView {
  return (QIHomeView *)self.view;
}

#pragma mark Factory Methods

- (QIQuizViewController *)newQuizViewController {
  QIQuizViewController *quizViewController = [[QIQuizViewController alloc] init];
  quizViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  quizViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  return quizViewController;
}

- (QICalendarPickerViewController *)newCalendarPickerViewController {
  QICalendarPickerViewController *calendarPickerViewController = [[QICalendarPickerViewController alloc] init];
  calendarPickerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  calendarPickerViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  calendarPickerViewController.view.frame = self.view.bounds;
  return calendarPickerViewController;
}
@end
