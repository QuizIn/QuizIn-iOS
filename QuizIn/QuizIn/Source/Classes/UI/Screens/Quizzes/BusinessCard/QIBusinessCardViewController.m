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
  self.businessCardQuizView.answerPerson = self.businessCardQuestion.person; 
  //todo add actual correct Indexes here. 
  self.businessCardQuizView.correctNameIndex = 1;
  self.businessCardQuizView.correctCompanyIndex = 1;
  self.businessCardQuizView.correctTitleIndex = 1;
  self.businessCardQuizView.loggedInUserID = @"12345";
  
  [self.businessCardQuizView.checkAnswersView.helpButton addTarget:self
                                                          action:@selector(helpDialog)
                                                forControlEvents:UIControlEventTouchUpInside];
  [self.businessCardQuizView.checkAnswersView.seeProfilesButton addTarget:self
                                                                 action:@selector(showActionSheet:)
                                                       forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Action Sheet Functions
- (void)showActionSheet:(id)sender{
  NSString *actionSheetTitle = @"Open LinkedIn Profile For:";
  NSString *other1 = [NSString stringWithFormat:@"%@ %@",self.businessCardQuestion.person.firstName,self.businessCardQuestion.person.lastName];
  NSString *cancelTitle = @"Cancel";
  UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                initWithTitle:actionSheetTitle
                                delegate:self
                                cancelButtonTitle:cancelTitle
                                destructiveButtonTitle:nil
                                otherButtonTitles:other1, nil];
  [actionSheet setOpaque:NO];
  [actionSheet setAlpha:.8f];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (buttonIndex) {
    case 0:{
      NSString *personID = self.businessCardQuestion.person.personID;
      NSString *actionUrl = [NSString stringWithFormat:@"linkedin://#profile/%@",personID];
      NSString *actionUrlWeb = self.businessCardQuestion.person.publicProfileURL;
      
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

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Business Card Question"
                                                  message:@"Swipe the answer selectors left and right to fill out the business card and touch Check Answers"
                                                 delegate:nil
                                        cancelButtonTitle:@"Thanks"
                                        otherButtonTitles:nil];
  for (UIView *view in alert.subviews) {
    if([[view class] isSubclassOfClass:[UILabel class]]) {
      [((UILabel*)view) setTextAlignment:NSTextAlignmentLeft];
    }
  }
  [alert show];

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
