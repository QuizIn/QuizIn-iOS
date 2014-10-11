
#import <UIKit/UIKit.h>
#import "QISearchPickerView.h"
#import "QISearchPickerTableViewCell.h"


@protocol QISearchPickerViewControllerDelegate <NSObject>
@required
- (void) addItemFromSearchView:(NSDictionary *)searchedItem;
@end


@interface QISearchPickerViewController : UIViewController

{
  // Delegate to respond back
  id <QISearchPickerViewControllerDelegate> _delegate;
  
}
@property (nonatomic,strong) id delegate;
- (QISearchPickerView *)searchView;

@end
 