#import "QIIndustrySelectionViewController.h"
#import "QIIndustrySearchPickerViewController.h"

#import "LinkedIn.h"
#import "QIIndustry.h"
#import "QIQuizFactory.h"
#import "QIQuizQuestion.h"
#import "QIIAPHelper.h"

@interface QIIndustrySelectionViewController ()

@end

@implementation QIIndustrySelectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.groupSelectionView setSelectionViewLabelString:@"Filter By Industries"];
  [LinkedIn
   topFirstDegreeConnectionIndustriesForAuthenticatedUserWithOnCompletion:^(NSArray *industries, NSError *error) {
     dispatch_async(dispatch_get_main_queue(), ^{
       if (error) {
         return;
       }
       
       NSMutableArray *industrySelectionContent = [NSMutableArray arrayWithCapacity:[industries count]];
       for (QIIndustry *industry in industries) {
         NSMutableDictionary *industrySelection = [@{@"IDs": industry.code,
                                                     @"title": industry.name,
                                                     @"subtitle": @"",
                                                     @"images": @[],
                                                     @"logo": [NSNull null],
                                                     @"selected": @NO} mutableCopy];
         [industrySelectionContent addObject:industrySelection];
       }
       [self.groupSelectionView setSelectionContent:[industrySelectionContent copy]];
       
       
     });
   }];
}

- (void)startQuiz:(id)sender {
  [super startQuiz:sender];
  
  NSMutableArray *selectedIndustryCodes = [NSMutableArray array];
  for (NSDictionary *industryDict in self.groupSelectionView.selectionContent) {
    if ([industryDict[@"selected"] isEqual:@YES]) {
      [selectedIndustryCodes addObject:industryDict[@"IDs"]];
    }
  }
  
  QIIAPHelper *store = [QIIAPHelper sharedInstance];
  
  QIQuizQuestionAllowedTypes questionTypes;
  if ([store productPurchased: @"com.kuhlmanation.hobnob.q_pack"]){
    questionTypes= QIQuizQuestionAllowAll;
  }
  else {
    questionTypes= QIQuizQuestionAllowMultipleChoice;
  }

  [QIQuizFactory
   newFirstDegreeQuizWithQuestionTypes:questionTypes
   forIndustries:selectedIndustryCodes
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
  QIIndustrySearchPickerViewController *searchController = [[QIIndustrySearchPickerViewController alloc] init];
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
