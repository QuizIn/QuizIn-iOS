#import "QICompanySelectionViewController.h"

#import "LinkedIn.h"
#import "QICompany.h"
#import "QIQuizFactory.h"
#import "QIQuizViewController.h"

@interface QICompanySelectionViewController ()
@end

@implementation QICompanySelectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [LinkedIn topFirstDegreeConnectionCompaniesForAuthentedUserWithOnCompletion:^(NSArray *companies,
                                                                                NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        return;
      }
      
      NSLog(@"Company Names: %@", companies);
      NSMutableArray *companySelectionContent = [NSMutableArray arrayWithCapacity:[companies count]];
      for (QICompany *company in companies) {
        NSMutableDictionary *companySelection = [@{@"contacts": company.companyID,
                                                   @"title": company.name,
                                                   @"subtitle": @"",
                                                   @"images": @[],
                                                   @"logo": [NSNull null],
                                                   @"selected": @NO} mutableCopy];
        [companySelectionContent addObject:companySelection];
      }
      [self.groupSelectionView setSelectionContent:[companySelectionContent copy]];
    });
  }];
}

- (void)startQuiz:(id)sender {
  [super startQuiz:sender];
  
  NSMutableArray *selectedCompanyCodes = [NSMutableArray array];
  for (NSDictionary *companyDict in self.groupSelectionView.selectionContent) {
    if ([companyDict[@"selected"] isEqual:@YES]) {
      [selectedCompanyCodes addObject:companyDict[@"contacts"]];
    }
  }
  
  [QIQuizFactory
   newFirstDegreeQuizWithQuestionTypes:(QIQuizQuestionTypeBusinessCard|
                                        QIQuizQuestionTypeMatching|
                                        QIQuizQuestionTypeMultipleChoice)
   forCurrentCompanies:selectedCompanyCodes
   completionBlock:^(QIQuiz *quiz, NSError *error) {
       if (error == nil) {
         dispatch_async(dispatch_get_main_queue(), ^{
           QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
           [self presentViewController:quizViewController animated:YES completion:nil];
         });
       }
  }];
}

@end
