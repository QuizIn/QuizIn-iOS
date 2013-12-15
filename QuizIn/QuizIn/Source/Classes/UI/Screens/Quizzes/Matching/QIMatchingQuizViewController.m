#import "QIMatchingQuizViewController.h"

#import "QIQuizQuestionViewController_Protected.h"
#import "QIMatchingQuestion.h"
#import "QIPerson.h"

@interface QIMatchingQuizViewController ()
@property(nonatomic, strong, readonly) QIMatchingQuestion *matchingQuestion;
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
  
  NSMutableArray *imageURLs = [NSMutableArray arrayWithCapacity:[self.matchingQuestion.people count]];
  for (QIPerson *person in self.matchingQuestion.people) {
    [imageURLs addObject:[NSURL URLWithString:person.pictureURL]];
  }
  self.matchingQuizView.questionImageURLs = [imageURLs copy];
  
  self.matchingQuizView.answers = self.matchingQuestion.answers;
  self.matchingQuizView.correctAnswers = self.matchingQuestion.correctAnswers;
  self.matchingQuizView.people = self.matchingQuestion.people;
  self.matchingQuizView.loggedInUserID = @"12345";
  
  [self.matchingQuizView.checkAnswersView.helpButton addTarget:self
                                                            action:@selector(helpDialog)
                                                  forControlEvents:UIControlEventTouchUpInside];
  [self.matchingQuizView.checkAnswersView.seeProfilesButton addTarget:self
                                                                   action:@selector(showActionSheet:)
                                                         forControlEvents:UIControlEventTouchUpInside];
  [self.matchingQuizView.rankDisplayView.exitButton addTarget:self.matchingQuizView
                                                       action:@selector(hideRankDisplay)
                                             forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark Action Sheet Functions
- (void)showActionSheet:(id)sender{
  NSString *actionSheetTitle = @"Open LinkedIn Profile For:";
  NSString *other0 = [NSString stringWithFormat:@"%@ %@",[[self.matchingQuestion.people objectAtIndex:0] firstName],[[self.matchingQuestion.people objectAtIndex:0] lastName]];
  NSString *other1 = [NSString stringWithFormat:@"%@ %@",[[self.matchingQuestion.people objectAtIndex:1] firstName],[[self.matchingQuestion.people objectAtIndex:1] lastName]];
  NSString *other2 = [NSString stringWithFormat:@"%@ %@",[[self.matchingQuestion.people objectAtIndex:2] firstName],[[self.matchingQuestion.people objectAtIndex:2] lastName]];
  NSString *other3 = [NSString stringWithFormat:@"%@ %@",[[self.matchingQuestion.people objectAtIndex:3] firstName],[[self.matchingQuestion.people objectAtIndex:3] lastName]];
  NSString *cancelTitle = @"Cancel";
  UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                initWithTitle:actionSheetTitle
                                delegate:self
                                cancelButtonTitle:cancelTitle
                                destructiveButtonTitle:nil
                                otherButtonTitles:other0, other1, other2, other3, nil];
  [actionSheet setOpaque:NO];
  [actionSheet setAlpha:.8f];
  [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex<=3){
    NSString *personID = [[self.matchingQuestion.people objectAtIndex:buttonIndex] personID];
    NSString *actionUrl = [NSString stringWithFormat:@"linkedin://#profile/%@",personID];
    NSString *actionUrlWeb = [[self.matchingQuestion.people objectAtIndex:buttonIndex] publicProfileURL];
    BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:actionUrl]];
    if (canOpenURL){
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionUrl]];
    }
    else {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionUrlWeb]];
    }
  }
}

#pragma mark Alert Functions

- (void)helpDialog{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@" Matching Question"
                                                  message:@"Alternate touches between the pictures and the answers to make matches. When everything is filled touch Check Answers."
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

- (QIMatchingQuestion *)matchingQuestion {
  return (QIMatchingQuestion *)self.question;
}

@end
