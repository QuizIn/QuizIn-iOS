#import "QIQuizFinishViewController.h"

@interface QIQuizFinishViewController ()

@end

@implementation QIQuizFinishViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView{
  self.view = [[QIQuizFinishView alloc] init];
  [self.quizFinishView setCorrectAnswers:5];
  [self.quizFinishView setTotalQuestions:11];
  [self.quizFinishView.continueButton addTarget:self
                                         action:@selector(dismiss)
                               forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

}

- (void)dismiss{
  [self dismissViewControllerAnimated:YES completion:nil]; 
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
