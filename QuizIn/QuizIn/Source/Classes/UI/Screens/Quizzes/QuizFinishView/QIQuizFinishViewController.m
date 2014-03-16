#import "QIQuizFinishViewController.h"
#import "QIPerson.h"
#import "LinkedIn.h"

@interface QIQuizFinishViewController ()

@property (nonatomic,strong) QIPerson *loggedInUser;

@end

@implementation QIQuizFinishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      _loggedInUser = [LinkedIn authenticatedUser];
    }
    return self;
}

- (void)loadView{
  self.view = [[QIQuizFinishView alloc] init];
  [self.quizFinishView setCorrectAnswers:self.correctAnswers];
  [self.quizFinishView setTotalQuestions:self.totalQuestions];
  [self.quizFinishView setProfileImageURL:[NSURL URLWithString:self.loggedInUser.pictureURL]];
  [self.quizFinishView.doneButton addTarget:self
                                         action:@selector(dismiss)
                               forControlEvents:UIControlEventTouchUpInside];
  
  [self.quizFinishView.goAgainButton addTarget:self
                                     action:@selector(goAgain)
                           forControlEvents:UIControlEventTouchUpInside];
}


- (void)viewDidLoad
{
  [super viewDidLoad];

}

- (void)dismiss{
  [self dismissViewControllerAnimated:YES completion:nil]; 
}

- (void)goAgain{
  NSLog(@"Quiz Again");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QIQuizFinishView *)quizFinishView {
  return (QIQuizFinishView *)self.view;
}


@end
