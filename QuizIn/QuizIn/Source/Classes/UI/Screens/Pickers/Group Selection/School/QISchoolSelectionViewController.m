#import "QISchoolSelectionViewController.h"
#import "QISchoolSearchPickerViewController.h"

#import "LinkedIn.h"
#import "QISchool.h"
#import "QIQuizFactory.h"
#import "QIIAPHelper.h"

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
        NSMutableDictionary *schoolSelection = [@{@"IDs": school.code,
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
      [selectedSchoolCodes addObject:schoolDict[@"IDs"]];
    }
  }
  
  
  QIIAPHelper *store = [QIIAPHelper sharedInstance];
  
  QIQuizQuestionAllowedTypes questionTypes;
  if ([store productPurchased: @"com.kuhlmanation.hobnob.q_pack"]){
    questionTypes = QIQuizQuestionAllowAll;
  }
  else {
    questionTypes = QIQuizQuestionAllowMultipleChoice;
  }
  
  [QIQuizFactory
   newFirstDegreeQuizWithQuestionTypes:questionTypes
   forSchools:selectedSchoolCodes
   completionBlock:^(QIQuiz *quiz, NSError *error) {
     if (error == nil) {
       dispatch_async(dispatch_get_main_queue(), ^{
         QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
         [self presentViewController:(UIViewController *)quizViewController animated:YES completion:nil];
       });
     }
     else {
       [self peopleAlert]; 
     }
   }];
}

- (void)showSearchView{
  QISchoolSearchPickerViewController *searchController = [[QISchoolSearchPickerViewController alloc] init];
  searchController.delegate = self;
  [searchController setModalPresentationStyle:UIModalPresentationFullScreen];
  [searchController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
  [self presentViewController:searchController animated:YES completion:nil];
}

- (void)addItemFromSearchView:(NSDictionary *)searchItem{
  NSMutableArray *selectionContentTemp = [self.groupSelectionView.selectionContent mutableCopy];
  [selectionContentTemp addObject:[@{@"IDs":      [searchItem objectForKey:@"ID"],
                                     @"title":    [searchItem objectForKey:@"name"],
                                     @"subtitle": [searchItem objectForKey:@"ID"],
                                     @"images":   @[],
                                     @"logo":     [NSNull null],
                                     @"selected": @YES} mutableCopy]];
  [self.groupSelectionView setSelectionContent:selectionContentTemp];
  
  
}

- (void)peopleAlert{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"More Peeps Needed" message:@"You gotta have at least 4 connections to create a quiz - any less and you should just peep their profiles." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
}



@end
