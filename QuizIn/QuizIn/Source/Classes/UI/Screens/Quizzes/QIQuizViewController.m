#import "QIQuizViewController.h"

#import "QIQuizView.h"
#import "QIMultipleChoiceQuizViewController.h"
#import "QIBusinessCardViewController.h"
#import "QIMatchingQuizViewController.h"
#import "QIQuizQuestionViewControllerFactory.h"
#import "QIProgressView.h"
#import "QIQuizFinishViewController.h"

#import "QIQuizFactory.h"
#import "QIQuiz.h"

@interface QIQuizViewController ()
@property(nonatomic, strong) QIQuiz *quiz;
@property(nonatomic, assign) NSUInteger questionIndex;
@property(nonatomic, strong, readonly) QIQuizView *quizView;
@property(nonatomic, strong) QIQuizQuestionViewController *currentQuestionViewController;

@property(nonatomic, strong) QIMultipleChoiceQuizViewController *multipleChoiceController;
@property(nonatomic, strong) QIBusinessCardViewController *businessCardController;
@property(nonatomic, strong) QIMatchingQuizViewController *matchingController;
@property(nonatomic, assign) NSInteger numberCorrect;
@end

@implementation QIQuizViewController

- (instancetype)initWithQuiz:(QIQuiz *)quiz {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _quiz = quiz;
    _businessCard = NO;
    _matching = NO;
    _questionIndex = 0;
    _numberCorrect = 0;
  }
  return self;
}


- (void)loadView {
  NSAssert(self.quiz != nil,
           @"Cannot load Quiz View Controller if it's not instantiated with a QIQuiz.");
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
  
  
  
  self.currentQuestionViewController =
  [QIQuizQuestionViewControllerFactory
   questionViewControllerForQuestion:(QIQuizQuestion *)[self.quiz nextQuestion]];
  self.questionIndex++;
  self.currentQuestionViewController.progressView.numberOfQuestions = self.quiz.numberOfQuestions;
  self.currentQuestionViewController.progressView.quizProgress = self.questionIndex;
  
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
}

#pragma mark Actions
- (void)nextPressed{
  if (self.currentQuestionViewController.isCorrect) {
    self.numberCorrect++;
  }
  [self.currentQuestionViewController.view removeFromSuperview];
  [self.currentQuestionViewController removeFromParentViewController];
  
  QIQuizQuestion *nextQuestion = (QIQuizQuestion *)[self.quiz nextQuestion];
  self.questionIndex++;
  
  
  if (nextQuestion == nil) {
    QIQuizFinishViewController *finishViewController = [[QIQuizFinishViewController alloc] init];
    finishViewController.correctAnswers = self.numberCorrect;
    finishViewController.totalQuestions = self.quiz.numberOfQuestions;
    [self addChildViewController:finishViewController];
    [self.view addSubview:finishViewController.view];
    finishViewController.view.frame = self.view.bounds;
    [finishViewController.view setNeedsUpdateConstraints];
    return;
  }
  
  QIQuizQuestionViewController *nextQuestionViewController =
      [QIQuizQuestionViewControllerFactory questionViewControllerForQuestion:nextQuestion];
  // TODO: Place this in a method.
  nextQuestionViewController.progressView.numberOfQuestions = self.quiz.numberOfQuestions;
  nextQuestionViewController.progressView.quizProgress = self.questionIndex;
  
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
  
  // TODO: Need to get rid of old view controllers.
  self.currentQuestionViewController = nextQuestionViewController;
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
