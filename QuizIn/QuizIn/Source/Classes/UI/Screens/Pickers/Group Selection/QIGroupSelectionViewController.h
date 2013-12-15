
#import <UIKit/UIKit.h>
#import "QIGroupSelectionView.h"
#import "QIGroupSelectionData.h"
#import "QISearchPickerViewController.h"

@class QIQuiz;
@class QIQuizViewController;

@interface QIGroupSelectionViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, strong) QIGroupSelectionView *groupSelectionView;

- (void)startQuiz:(id)sender;
- (QIQuizViewController *)newQuizViewControllerWithQuiz:(QIQuiz *)quiz;

@end
