#import "QISchoolSelectionViewController.h"

#import "LinkedIn.h"
#import "QISchool.h"
#import "QIQuizFactory.h"

@interface QISchoolSelectionViewController ()

@end

@implementation QISchoolSelectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.groupSelectionView setSelectionViewLabelString:@"Filter By Schools"];
  
  [LinkedIn topFirstDegreeConnectionSchoolsForAuthenticatedUserWithOnCompletion:^(NSArray *schools, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        return;
      }
      
      NSMutableArray *schoolSelectionContent = [NSMutableArray arrayWithCapacity:[schools count]];
      for (QISchool *school in schools) {
        NSMutableDictionary *schoolSelection = [@{@"contacts": school.code,
                                                  @"title": school.name,
                                                  @"subtitle": @"",
                                                  @"images": @[],
                                                  @"logo": [NSNull null],
                                                  @"selected": @NO} mutableCopy];
        [schoolSelectionContent addObject:schoolSelection];
      }
      [self.groupSelectionView setSelectionContent:[schoolSelectionContent copy]];
    });
  }];
}

- (void)startQuiz:(id)sender {
  [super startQuiz:sender];
  
  NSMutableArray *selectedSchoolCodes = [NSMutableArray array];
  for (NSDictionary *schoolDict in self.groupSelectionView.selectionContent) {
    if ([schoolDict[@"selected"] isEqual:@YES]) {
      [selectedSchoolCodes addObject:schoolDict[@"contacts"]];
    }
  }
  
  [QIQuizFactory
   newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionTypeBusinessCard|
                                        QIQuizQuestionTypeMatching|
                                        QIQuizQuestionTypeMultipleChoice)
   forSchools:selectedSchoolCodes
   completionBlock:^(QIQuiz *quiz, NSError *error) {
     if (error == nil) {
       dispatch_async(dispatch_get_main_queue(), ^{
         QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
         [self presentViewController:(UIViewController *)quizViewController animated:YES completion:nil];
       });
     }
   }];
}

@end
