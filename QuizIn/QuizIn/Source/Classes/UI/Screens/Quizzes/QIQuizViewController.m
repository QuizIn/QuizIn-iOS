#import "QIQuizViewController.h"

#import "QIQuizView.h"
#import "QIMultipleChoiceQuizViewController.h"
#import "QIBusinessCardViewController.h"
#import "QIMatchingQuizViewController.h"

#import "QIQuizBuilder.h"
#import "QIQuiz.h"

@interface QIQuizViewController ()
@property(nonatomic, strong) QIQuiz *quiz;
@property(nonatomic, strong, readonly) QIQuizView *quizView;
@property(nonatomic, strong) QIMultipleChoiceQuizViewController *multipleChoiceController;
@property(nonatomic, strong) QIBusinessCardViewController *businessCardController;
@property(nonatomic, strong) QIMatchingQuizViewController *matchingController;
@end

@implementation QIQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _businessCard = NO;
    _matching = NO;
  }
  return self;
}

- (void)loadView {
  self.view = [[QIQuizView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if (self.businessCard) {
    self.businessCardController = [[QIBusinessCardViewController alloc] init];
    [self addChildViewController:self.businessCardController];
    [self.businessCardController.businessCardQuizView.checkAnswersView.nextButton addTarget:self
                                                                            action:@selector(nextPressed1)
                                                                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.businessCardController.view];
    return;
  }
  
  if (self.matching) {
    self.matchingController = [[QIMatchingQuizViewController alloc] init];
    [self addChildViewController:self.matchingController];
    [self.matchingController.matchingQuizView.checkAnswersView.nextButton addTarget:self
                                                                    action:@selector(nextPressed1)
                                                          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.matchingController.view];
    return;
  }
  
  
  [QIQuizBuilder quizFromRandomConnectionsWithCompletionBlock:^(QIQuiz *quiz, NSError *error) {
    if (error == nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.quiz = quiz;
        self.multipleChoiceController =
        [[QIMultipleChoiceQuizViewController alloc]
         initWithQuestion:(QIMultipleChoiceQuestion *)[self.quiz nextQuestion]];
        [self addChildViewController:self.multipleChoiceController];
        [self.view addSubview:self.multipleChoiceController.view];
        [self.multipleChoiceController.multipleChoiceView.checkAnswersView.nextButton addTarget:self
                                                                                         action:@selector(nextPressed)
                                                                               forControlEvents:UIControlEventTouchUpInside];
        [self.multipleChoiceController.multipleChoiceView.rankDisplayView.rankShareButton addTarget:self
                                                                                             action:@selector(shareRankPressed)
                                                                                   forControlEvents:UIControlEventTouchUpInside];
        [self.multipleChoiceController.multipleChoiceView.progressView.exitButton addTarget:self
                                                                                     action:@selector(userDidCloseQuiz)
                                                                           forControlEvents:UIControlEventTouchUpInside];

      });
    }
  }];
}

#pragma mark Actions
- (void)nextPressed{
  [self.multipleChoiceController.view removeFromSuperview];
  [self.multipleChoiceController removeFromParentViewController];
  
  QIMultipleChoiceQuestion *nextQuestion = (QIMultipleChoiceQuestion *)[self.quiz nextQuestion];
  
  if (nextQuestion == nil) {
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
  }
  
  QIMultipleChoiceQuizViewController *nextQuestionViewController =
      [[QIMultipleChoiceQuizViewController alloc] initWithQuestion:nextQuestion];
  
  //Todo Combine this into a reusable function 
  [nextQuestionViewController.multipleChoiceView.checkAnswersView.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
  [nextQuestionViewController.multipleChoiceView.checkAnswersView.nextButton addTarget:self
                                                                                   action:@selector(nextPressed)
                                                                         forControlEvents:UIControlEventTouchUpInside];
  [nextQuestionViewController.multipleChoiceView.rankDisplayView.rankShareButton addTarget:self
                                                                                       action:@selector(shareRankPressed)
                                                                             forControlEvents:UIControlEventTouchUpInside];
  [nextQuestionViewController.multipleChoiceView.progressView.exitButton addTarget:self
                                                                               action:@selector(userDidCloseQuiz)
                                                                     forControlEvents:UIControlEventTouchUpInside];
  
  [self addChildViewController:nextQuestionViewController];
  [self.view addSubview:nextQuestionViewController.view];
}

- (void)nextPressed1{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareRankPressed{
  NSLog(@"ShareCurrentRank");
}

- (void)userDidCloseQuiz{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Layout

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  self.multipleChoiceController.view.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions


#pragma mark Properties

- (QIQuizView *)quizView {
  return (QIQuizView *)self.view;
}

@end
