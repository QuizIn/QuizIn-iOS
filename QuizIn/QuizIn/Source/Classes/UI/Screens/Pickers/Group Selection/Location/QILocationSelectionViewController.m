#import "QILocationSelectionViewController.h"
#import "QILocationSearchPickerViewController.h"

#import "LinkedIn.h"
#import "QILocation.h"
#import "QIQuizFactory.h"
#import "QIIAPHelper.h"

@interface QILocationSelectionViewController ()

@end

@implementation QILocationSelectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
    [self.groupSelectionView setSelectionViewLabelString:@"Filter By Locations"];
  
  [LinkedIn topFirstDegreeConnectionLocationsForAuthenticatedUserWithOnCompletion:^(NSArray *locations, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        return;
      }
      
      NSMutableArray *locationSelectionContent = [NSMutableArray arrayWithCapacity:[locations count]];
      for (QILocation *location in locations) {
        NSMutableDictionary *locationSelection = [@{@"contacts": location.countryCode,
                                                    @"title": location.name,
                                                    @"subtitle": @"",
                                                    @"images": @[],
                                                    @"logo": [NSNull null],
                                                    @"selected": @NO} mutableCopy];
        [locationSelectionContent addObject:locationSelection];
      }
      [self.groupSelectionView setSelectionContent:[locationSelectionContent copy]];
    });
  }];
}

- (void)startQuiz:(id)sender {
  [super startQuiz:sender];
  
  NSMutableArray *selectedLocationCodes = [NSMutableArray array];
  for (NSDictionary *locationDict in self.groupSelectionView.selectionContent) {
    if ([locationDict[@"selected"] isEqual:@YES]) {
      [selectedLocationCodes addObject:locationDict[@"contacts"]];
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
   forLocations:selectedLocationCodes
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
  QILocationSearchPickerViewController *searchController = [[QILocationSearchPickerViewController alloc] init];
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
