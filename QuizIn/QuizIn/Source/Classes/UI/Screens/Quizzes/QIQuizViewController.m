#import "QIQuizViewController.h"

#import "QIQuizView.h"
#import "QIMultipleChoiceQuizViewController.h"
#import "QIBusinessCardViewController.h"
#import "QIMatchingQuizViewController.h"
#import "QIQuizQuestionViewControllerFactory.h"

#import "QIQuizFactory.h"
#import "QIQuiz.h"

@interface QIQuizViewController ()
@property(nonatomic, strong) QIQuiz *quiz;
@property(nonatomic, strong, readonly) QIQuizView *quizView;
@property(nonatomic, strong) QIQuizQuestionViewController *currentQuestionViewController;

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
  
  
  [QIQuizFactory quizFromRandomConnectionsWithCompletionBlock:^(QIQuiz *quiz, NSError *error) {
    if (error == nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        self.quiz = quiz;
        self.currentQuestionViewController =
            [QIQuizQuestionViewControllerFactory
             questionViewControllerForQuestion:(QIQuizQuestion *)[self.quiz nextQuestion]];

        [self addChildViewController:self.currentQuestionViewController];
        [self.view addSubview:self.currentQuestionViewController.view];
        [self.currentQuestionViewController.checkAnswersView.nextButton addTarget:self
                                                                           action:@selector(nextPressed)
                                                                 forControlEvents:UIControlEventTouchUpInside];
        [self.currentQuestionViewController.rankDisplayView.fbShareButton addTarget:self
                                                                               action:@selector(shareRankPressed)
                                                                     forControlEvents:UIControlEventTouchUpInside];
        [self.currentQuestionViewController.progressView.exitButton addTarget:self
                                                                       action:@selector(userDidCloseQuiz)
                                                             forControlEvents:UIControlEventTouchUpInside];

      });
    }
  }];
}

#pragma mark Actions
- (void)nextPressed{
  [self.currentQuestionViewController.view removeFromSuperview];
  [self.currentQuestionViewController removeFromParentViewController];
  
  QIQuizQuestion *nextQuestion = (QIQuizQuestion *)[self.quiz nextQuestion];
  
  if (nextQuestion == nil) {
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
  }
  
  QIQuizQuestionViewController *nextQuestionViewController =
      [QIQuizQuestionViewControllerFactory questionViewControllerForQuestion:nextQuestion];
  
  [nextQuestionViewController.checkAnswersView.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
  [nextQuestionViewController.checkAnswersView.nextButton addTarget:self
                                                             action:@selector(nextPressed)
                                                   forControlEvents:UIControlEventTouchUpInside];
  [nextQuestionViewController.rankDisplayView.fbShareButton addTarget:self
                                                                 action:@selector(shareRankPressed)
                                                       forControlEvents:UIControlEventTouchUpInside];
  [nextQuestionViewController.progressView.exitButton addTarget:self
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
