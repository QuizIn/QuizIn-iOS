

#import "QIGroupSelectionViewController.h"
#import "QIQuizFactory.h"
#import "QIQuizViewController.h"

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
  NSMutableArray *selectionContent = [QIGroupSelectionData getSelectionData];
  [self.groupSelectionView setSelectionContent:selectionContent];
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
  [QIQuizFactory newFirstDegreeQuizForIndustry:@"96" withCompletionBlock:^(QIQuiz *quiz, NSError *error) {
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
