#import "QIMatchingQuizViewController.h"

#import "QIQuizQuestionViewController_Protected.h"

@interface QIMatchingQuizViewController ()

@end

@implementation QIMatchingQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView{
  self.view = [[QIMatchingQuizView alloc] init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.matchingQuizView.numberOfQuestions = 10;
  self.matchingQuizView.quizProgress = 4;
  self.matchingQuizView.questionImageURLs = @[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                                              [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                                              [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"],
                                              [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/080/035/28eea75.jpg"]];
  self.matchingQuizView.answers = @[@"Knoxville Fellows",@"Invodo",@"Mutual Mobile",@"Google"];
  self.matchingQuizView.loggedInUserID = @"12345";
  
  [self.matchingQuizView.checkAnswersView.helpButton addTarget:self
                                                            action:@selector(helpDialog)
                                                  forControlEvents:UIControlEventTouchUpInside];
  [self.matchingQuizView.checkAnswersView.seeProfilesButton addTarget:self
                                                                   action:@selector(showActionSheet:)
                                                         forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark Action Sheet Functions
- (void)showActionSheet:(id)sender{
  NSString *actionSheetTitle = @"Open LinkedIn Profile For:";
  //todo add array of people
  NSString *other1 = @"Bunch of People";
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
      //todo add array of people here 
      NSString *personID = @"12345"; 
      NSString *actionUrl = [NSString stringWithFormat:@"linkedin://#profile/%@",personID];
      NSString *actionUrlWeb = @"www.linkedin.com/pub/rick-kuhlman/1a/531/ba/"; 
      
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
  for (UIView *view in alert.subviews) {
    if([[view class] isSubclassOfClass:[UILabel class]]) {
      [((UILabel*)view) setTextAlignment:NSTextAlignmentLeft];
    }
  }
  [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QIMatchingQuizView *)matchingQuizView {
  return (QIMatchingQuizView *)self.view;
}

@end
