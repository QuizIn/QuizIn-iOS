#import "QIMultipleChoiceQuizViewController.h"

@interface QIMultipleChoiceQuizViewController ()

@end

@implementation QIMultipleChoiceQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)loadView {
  self.view = [[QIMultipleChoiceQuizView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  //TODO Cleanup hardcoded test values
  self.multipleChoiceView.numberOfQuestions = 11;
  self.multipleChoiceView.quizProgress = 10;
  self.multipleChoiceView.question = @"Where do I work?";
  self.multipleChoiceView.answers = @[@"National Instruments",@"Invodo",@"Mutual Mobile",@"Google"];
  [self.multipleChoiceView.progressView.exitButton addTarget:self
                                                      action:@selector(userDidCloseQuiz)
                                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.multipleChoiceView.nextQuestionButton addTarget:self
                                                 action:@selector(userDidPressNext)
                                       forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions
- (void)userDidCloseQuiz{
  NSLog(@"User Closed Quiz");
}
- (void)userDidPressNext{
  NSLog(@"userHit Next");
}

#pragma mark Properties

- (QIMultipleChoiceQuizView *)multipleChoiceView {
  return (QIMultipleChoiceQuizView *)self.view;
}

@end
