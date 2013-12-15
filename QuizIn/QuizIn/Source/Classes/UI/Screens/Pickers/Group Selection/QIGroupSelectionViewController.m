#import "QIGroupSelectionViewController.h"
#import "QIQuizFactory.h"
#import "QIQuizViewController.h"
#import "QICompany.h"
#import "QIIndustry.h"
#import "QILocation.h"
#import "QISchool.h"
#import "LinkedIn.h"

@interface QIGroupSelectionViewController ()

@end


@implementation QIGroupSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

-(void)loadView {
  self.view = [[QIGroupSelectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
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
  
  /*
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
  }];*/
  
  
  /*
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
   }];*/
  
  /*
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
  }];*/
  
  [self.groupSelectionView setSelectionContent:[@[] mutableCopy]];
  [self.groupSelectionView setSelectionViewLabelString:@"Create Your Next Quiz"];
  
  [self.groupSelectionView.backButton addTarget:self
                                         action:@selector(backButtonPressed)
                               forControlEvents:UIControlEventTouchUpInside];
  
  [self.groupSelectionView.quizButton addTarget:self
                                         action:@selector(startQuiz:)
                               forControlEvents:UIControlEventTouchUpInside];
  
  [self.groupSelectionView.footerView.searchButton addTarget:self
                                                      action:@selector(showSearchView)
                                            forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Actions
- (void)showSearchView{
  QISearchPickerViewController *searchController = [[QISearchPickerViewController alloc] init];
  [searchController setModalPresentationStyle:UIModalPresentationFullScreen];
  [searchController setModalTransitionStyle:UIModalTransitionStyleCoverVertical]; 
  [self presentViewController:searchController animated:YES completion:nil];
}

- (void)backButtonPressed{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startQuiz:(id)sender {
  NSMutableArray *selectedCompanyCodes = [NSMutableArray array];
  for (NSDictionary *companyDict in self.groupSelectionView.selectionContent) {
    if ([companyDict[@"selected"] isEqual:@YES]) {
      [selectedCompanyCodes addObject:companyDict[@"contacts"]];
    }
  }
  
  [QIQuizFactory newFirstDegreeQuizForCurrentCompanies:selectedCompanyCodes
                                   withCompletionBlock:^(QIQuiz *quiz, NSError *error) {
    if (error == nil) {
      dispatch_async(dispatch_get_main_queue(), ^{
        QIQuizViewController *quizViewController = [self newQuizViewControllerWithQuiz:quiz];
        [self presentViewController:quizViewController animated:YES completion:nil];
      });
    }
  }];
}

- (QIQuizViewController *)newQuizViewControllerWithQuiz:(QIQuiz *)quiz {
  QIQuizViewController *quizViewController = [[QIQuizViewController alloc] initWithQuiz:quiz];
  quizViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  quizViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
  return quizViewController;
}

- (QIGroupSelectionView *)groupSelectionView {
  return (QIGroupSelectionView *)self.view;
}

@end
