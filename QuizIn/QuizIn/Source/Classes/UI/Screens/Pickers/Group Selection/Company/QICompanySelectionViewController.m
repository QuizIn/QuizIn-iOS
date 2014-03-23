#import "QICompanySelectionViewController.h"

#import "LinkedIn.h"
#import "QICompany.h"
#import "QIQuizFactory.h"
#import "QIQuizViewController.h"

@interface QICompanySelectionViewController ()

@property (nonatomic, strong) NSMutableArray *companyIDs;

@end

@implementation QICompanySelectionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.groupSelectionView setSelectionViewLabelString:@"Filter By Companies"];
  
  [LinkedIn topFirstDegreeConnectionCompaniesForAuthentedUserWithOnCompletion:^(NSArray *companies,
                                                                                NSError *error) {
    if (error && [companies count]==0){
      NSLog(@"LINKEDIN ERROR: %@", error.description);
    }
    else{
      self.companyIDs = [NSMutableArray arrayWithCapacity:[companies count]];
      for (QICompany *company in companies){
        [self.companyIDs addObject:company.companyID];
      }
    }
    
    [LinkedIn companiesWithIDs:self.companyIDs onCompletion:^(NSArray *companies, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
          return;
        }
        
        NSMutableArray *companySelectionContent = [NSMutableArray arrayWithCapacity:[companies count]];
        for (QICompany *company in companies) {
          NSMutableDictionary *companySelection = [@{@"contacts": @"0",
                                                     @"title": company.name,
                                                     @"subtitle": company.industry,
                                                     @"images": @[],
                                                     @"logo": [NSURL URLWithString:company.logoURLString],
                                                     @"selected": @NO} mutableCopy];
          [companySelectionContent addObject:companySelection];
        }
        [self.groupSelectionView setSelectionContent:[companySelectionContent copy]];
      });
      
    }];
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
