#import "QIBusinessCardViewController.h"


@interface QIBusinessCardViewController ()

@end

@implementation QIBusinessCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}
- (void)loadView{
  self.view = [[QIBusinessCardQuizView alloc] init];
}
- (void)viewDidLoad {
  [super viewDidLoad];
  self.businessCardQuizView.numberOfQuestions = 10;
  self.businessCardQuizView.quizProgress = 4;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (QIBusinessCardQuizView *)businessCardQuizView {
  return (QIBusinessCardQuizView *)self.view;
}

@end
