#import "QIMultipleChoiceQuizViewController.h"

#import "QIQuizQuestionViewController_Protected.h"
#import "QIMultipleChoiceQuestion.h"
#import "QIPerson.h"

@interface QIMultipleChoiceQuizViewController ()
@property(nonatomic, strong, readonly) QIMultipleChoiceQuestion *multipleChoiceQuestion;
@end

@implementation QIMultipleChoiceQuizViewController

- (void)loadView {
  self.view = [[QIMultipleChoiceQuizView alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.multipleChoiceView.numberOfQuestions = 11;
  self.multipleChoiceView.quizProgress = 10;
  self.multipleChoiceView.question = self.multipleChoiceQuestion.questionPrompt;
  self.multipleChoiceView.answers = self.multipleChoiceQuestion.answers;
  self.multipleChoiceView.correctAnswerIndex = self.multipleChoiceQuestion.correctAnswerIndex;
  self.multipleChoiceView.profileImageURL = [NSURL URLWithString:self.multipleChoiceQuestion.person.pictureURL];
  self.multipleChoiceView.loggedInUserID = @"12345";
  self.multipleChoiceView.answerPerson = self.multipleChoiceQuestion.person;

  [self.multipleChoiceView.checkAnswersView.helpButton addTarget:self
                                                          action:@selector(helpDialog)
                                                forControlEvents:UIControlEventTouchUpInside];
  [self.multipleChoiceView.checkAnswersView.seeProfilesButton addTarget:self
                                                                 action:@selector(showActionSheet:)
                                                       forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


#pragma mark Properties

- (QIMultipleChoiceQuizView *)multipleChoiceView {
  return (QIMultipleChoiceQuizView *)self.view;
}

#pragma mark Action Sheet Functions
- (void)showActionSheet:(id)sender{
  NSString *actionSheetTitle = @"Open LinkedIn Profile For:";
  NSString *other1 = [NSString stringWithFormat:@"%@ %@",self.multipleChoiceQuestion.person.firstName,self.multipleChoiceQuestion.person.lastName];
  NSString *cancelTitle = @"Cancel";
  UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                initWithTitle:actionSheetTitle
                                delegate:self
                                cancelButtonTitle:cancelTitle
                                destructiveButtonTitle:nil
                                otherButtonTitles:other1, nil];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:{
      NSString *personID = self.multipleChoiceQuestion.person.personID;
      NSString *actionUrl = [NSString stringWithFormat:@"linkedin://#profile/%@",personID];
      NSString *actionUrlWeb = [NSString stringWithFormat:@"http://www.linkedin.com/profile/view?id=%@",personID];
      
      BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:actionUrl]];
      if (canOpenURL){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionUrl]];
      }
      else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionUrlWeb]];
      }
      break;
    }
      
    default:
      break;
  }
}

#pragma mark Alert Functions

- (void)helpDialog{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Multiple Choice Question"
                                                  message:@"1) Click the correct answer\n2) Press 'Check Answers'\n3) 'Continue'"
                                                 delegate:nil
                                        cancelButtonTitle:@"Thanks"
                                        otherButtonTitles:nil];
  [alert show];
}

- (QIMultipleChoiceQuestion *)multipleChoiceQuestion {
  return (QIMultipleChoiceQuestion *)self.question;
}

@end
