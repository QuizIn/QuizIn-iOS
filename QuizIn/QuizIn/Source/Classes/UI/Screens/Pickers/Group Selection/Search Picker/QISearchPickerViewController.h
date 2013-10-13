
#import <UIKit/UIKit.h>
#import "QISearchPickerView.h"
#import "QISearchPickerTableViewCell.h"

@interface QISearchPickerViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) QISearchPickerView *searchView; 

@end
