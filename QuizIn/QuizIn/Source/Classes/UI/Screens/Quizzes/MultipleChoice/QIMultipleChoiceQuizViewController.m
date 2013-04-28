#import "QIMultipleChoiceQuizViewController.h"

#import "QIMultipleChoiceQuizView.h"

@interface QIMultipleChoiceQuizViewController ()
@property(nonatomic, strong, readonly) QIMultipleChoiceQuizView *multipleChoiceView;
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
  self.multipleChoiceView.quizProgress = 1;
  self.multipleChoiceView.numberOfQuestions = 10;
  self.multipleChoiceView.question = @"Where do I work?";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Properties

- (QIMultipleChoiceQuizView *)multipleChoiceView {
  return (QIMultipleChoiceQuizView *)self.view;
}

@end
