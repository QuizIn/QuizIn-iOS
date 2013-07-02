#import "QIMultipleChoiceQuizViewController.h"

#import "QIMultipleChoiceQuestion.h"
#import "QIPerson.h"

@interface QIMultipleChoiceQuizViewController ()
@property(nonatomic, strong) QIMultipleChoiceQuestion *question;
@end

@implementation QIMultipleChoiceQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  return [self initWithQuestion:nil];
};

- (instancetype)initWithQuestion:(QIMultipleChoiceQuestion *)question {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _question = question;
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
  self.multipleChoiceView.question = self.question.questionPrompt;
  self.multipleChoiceView.answers = self.question.answers;
  self.multipleChoiceView.profileImageURL = [NSURL URLWithString:self.question.person.pictureURL];
  [self.multipleChoiceView.progressView.exitButton addTarget:self
                                                      action:@selector(userDidCloseQuiz)
                                            forControlEvents:UIControlEventTouchUpInside];
  
  [self.multipleChoiceView.checkAnswersView.nextButton addTarget:self
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
