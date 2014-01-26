#import "QILocationSelectionViewController.h"

#import "LinkedIn.h"
#import "QILocation.h"
#import "QIQuizFactory.h"

@interface QILocationSelectionViewController ()

@end

@implementation QILocationSelectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
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
  
  [QIQuizFactory
   newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionTypeBusinessCard|
                                        QIQuizQuestionTypeMatching|
                                        QIQuizQuestionTypeMultipleChoice)
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

@end
