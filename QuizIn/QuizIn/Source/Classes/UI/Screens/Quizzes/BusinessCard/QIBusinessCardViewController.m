#import "QIBusinessCardViewController.h"

#import "QIQuizQuestionViewController_Protected.h"

#import "QIBusinessCardQuestion.h"
#import "QIPerson.h"

@interface QIBusinessCardViewController ()
@property(nonatomic, strong, readonly) QIBusinessCardQuestion *businessCardQuestion;
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
  self.businessCardQuizView.questionImageURL = [NSURL URLWithString:self.businessCardQuestion.person.pictureURL];
  self.businessCardQuizView.answerNames = self.businessCardQuestion.names;
  self.businessCardQuizView.answerCompanies = self.businessCardQuestion.companies;
  self.businessCardQuizView.answerTitles = self.businessCardQuestion.titles;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (QIBusinessCardQuizView *)businessCardQuizView {
  return (QIBusinessCardQuizView *)self.view;
}

- (QIBusinessCardQuestion *)businessCardQuestion {
  return (QIBusinessCardQuestion *)self.question;
}

@end
