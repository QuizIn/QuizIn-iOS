#import "QIQuizViewController.h"

#import "QIQuizView.h"
#import "QIMultipleChoiceQuizViewController.h"
#import "QIBusinessCardViewController.h"
#import "QIMatchingQuizViewController.h"

@interface QIQuizViewController ()
@property(nonatomic, strong, readonly) QIQuizView *quizView;
@property(nonatomic, strong) QIMultipleChoiceQuizViewController *multipleChoiceController;
@property(nonatomic, strong) QIBusinessCardViewController *businessCardController;
@property(nonatomic, strong) QIMatchingQuizViewController *matchingController;
@end

@implementation QIQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)loadView {
  self.view = [[QIQuizView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // TODO(rcacheaux): Clean up.
  
  self.multipleChoiceController = [[QIMultipleChoiceQuizViewController alloc] init];
  [self addChildViewController:self.multipleChoiceController];
    
  self.matchingController = [[QIMatchingQuizViewController alloc] init];
  [self addChildViewController:self.matchingController];

  self.businessCardController = [[QIBusinessCardViewController alloc] init];
  [self addChildViewController:self.businessCardController];
  [self.businessCardController.businessCardQuizView.nextQuestionButton addTarget:self action:@selector(nextPressed1) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.multipleChoiceController.view];
  [self.multipleChoiceController.multipleChoiceView.nextQuestionButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)nextPressed{
  [self.multipleChoiceController.view removeFromSuperview];
  [self.multipleChoiceController removeFromParentViewController];
  [self.view addSubview:self.businessCardController.view];
}

- (void)nextPressed1{
  [self.businessCardController.view removeFromSuperview];
  [self.businessCardController removeFromParentViewController];
  [self.view addSubview:self.matchingController.view];
}

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
