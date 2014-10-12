#import "QIIndustrySelectionViewController.h"
#import "QIIndustrySearchPickerViewController.h"

#import "LinkedIn.h"
#import "QIIndustry.h"
#import "QIQuizFactory.h"
#import "QIQuizQuestion.h"

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
         NSMutableDictionary *industrySelection = [@{@"contacts": industry.code,
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
      [selectedIndustryCodes addObject:industryDict[@"contacts"]];
    }
  }
  
  [QIQuizFactory
   newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionTypeBusinessCard|
                                        QIQuizQuestionTypeMatching|
                                        QIQuizQuestionTypeMultipleChoice)
   forIndustries:selectedIndustryCodes
   completionBlock:^(QIQuiz *quiz, NSError *error) {
     if (error == nil) {
       dispatch_async(dispatch_get_main_queue(), ^{
         QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
         [self presentViewController:(UIViewController *)quizViewController animated:YES completion:nil];
       });
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
  NSMutableArray *selectionContentTemp = self.groupSelectionView.selectionContent;
  [selectionContentTemp addObject:[@{@"IDs":      [searchItem objectForKey:@"ID"],
                                     @"title":    [searchItem objectForKey:@"name"],
                                     @"subtitle": [searchItem objectForKey:@"ID"],
                                     @"images":   @[],
                                     @"logo":     [NSNull null],
                                     @"selected": @YES} mutableCopy]];
  [self.groupSelectionView setSelectionContent:selectionContentTemp];
  
  
}



@end
