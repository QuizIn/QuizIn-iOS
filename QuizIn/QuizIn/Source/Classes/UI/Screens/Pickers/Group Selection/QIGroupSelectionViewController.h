
#import <UIKit/UIKit.h>
#import "QIGroupSelectionView.h"
#import "QIGroupSelectionData.h"
#import "QISearchPickerViewController.h"

@interface QIGroupSelectionViewController : UIViewController <UISearchBarDelegate>

@property (nonatomic, strong) QIGroupSelectionView *groupSelectionView;

@end
