#import "QICompanySelectionViewController.h"
#import "QICompanySearchPickerViewController.h"

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
          NSMutableDictionary *companySelection = [@{@"IDs": company.companyID,
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
      [selectedCompanyCodes addObject:companyDict[@"IDs"]];
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

- (void)showSearchView{
  QICompanySearchPickerViewController *searchController = [[QICompanySearchPickerViewController alloc] init];
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
                                     @"logo":     [NSURL URLWithString:@"https://avatars0.githubusercontent.com/u/1337932?v=2&s=40"],
                                     @"selected": @YES} mutableCopy]];
  [self.groupSelectionView setSelectionContent:selectionContentTemp];
  

}

@end
