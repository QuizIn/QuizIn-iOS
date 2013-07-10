#import "QIHomeViewController.h"

#import "QIHomeView.h"
#import "QIQuizViewController.h"
#import "QIGroupSelectionViewController.h"
#import "QIStatsViewController.h"

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
                                         action:@selector(groupPicker)
                               forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.businessCardQuizButton addTarget:self
                                           action:@selector(openBusinessCardQuiz:)
                                 forControlEvents:UIControlEventTouchUpInside];
  [self.homeView.matchingQuizButton addTarget:self
                                       action:@selector(openMatchingQuiz:)
                             forControlEvents:UIControlEventTouchUpInside];
  
  [self.homeView.statsViewButton addTarget:self
                                       action:@selector(openStatsView:)
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

- (void)openBusinessCardQuiz:(id)sender {
  QIQuizViewController *quizViewController = [self newQuizViewController];
  quizViewController.businessCard = YES;
  [self presentViewController:quizViewController animated:YES completion:nil];
}

- (void)openMatchingQuiz:(id)sender {
  QIQuizViewController *quizViewController = [self newQuizViewController];
  quizViewController.matching = YES;
  [self presentViewController:quizViewController animated:YES completion:nil];
}

- (void)openStatsView:(id)sender {
  QIStatsViewController *statsViewController = [self newStatsViewController];
  [self presentViewController:statsViewController animated:YES completion:nil];
}

- (void)groupPicker{
  QIGroupSelectionViewController *groupSelectionViewController = [self newGroupSelectionViewController];
  [self presentViewController:groupSelectionViewController animated:YES completion:nil];
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

- (QIGroupSelectionViewController *)newGroupSelectionViewController {
  QIGroupSelectionViewController *groupSelectionViewController = [[QIGroupSelectionViewController alloc] init];
  groupSelectionViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  groupSelectionViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  groupSelectionViewController.view.frame = self.view.bounds;
  return groupSelectionViewController;
}
- (QIStatsViewController *)newStatsViewController {
  QIStatsViewController *statsViewController = [[QIStatsViewController alloc] init];
  statsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  statsViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  statsViewController.view.frame = self.view.bounds;
  return statsViewController;
}
@end
