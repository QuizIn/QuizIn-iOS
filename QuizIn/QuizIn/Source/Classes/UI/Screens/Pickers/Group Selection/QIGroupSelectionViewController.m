#import "QIGroupSelectionViewController.h"
#import "QIQuizFactory.h"
#import "QIQuizViewController.h"
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
  
  
  [LinkedIn topFirstDegreeConnectionCompaniesForAuthentedUserWithOnCompletion:^(NSArray *companies,
                                                                                NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        return;
      }
      
      NSArray *imageURLs = @[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                             [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                             [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"],
                             [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/080/035/28eea75.jpg"],
                             [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                             [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                             [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"]];
      NSURL *logo1 = [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/media/p/2/000/01c/2c3/24f005d.png"];

      
      
      NSLog(@"Company Names: %@", companies);
      NSMutableArray *companySelectionContent = [NSMutableArray arrayWithCapacity:[companies count]];
      for (NSString *companyName in companies) {
        NSMutableDictionary *companySelection = [@{@"contacts": @"123",
                                                   @"title": companyName,
                                                   @"subtitle": @"",
                                                   @"images": imageURLs,
                                                   @"logo": logo1,
                                                   @"selected": @NO} mutableCopy];
        [companySelectionContent addObject:companySelection];
      }
      [self.groupSelectionView setSelectionContent:[companySelectionContent copy]];
    });
  }];
  
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
  [QIQuizFactory newFirstDegreeQuizForLocations:@[@"in:0", @"us:84", @"hu:0", @"us:70", @"mx:0"] withCompletionBlock:^(QIQuiz *quiz, NSError *error) {
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
