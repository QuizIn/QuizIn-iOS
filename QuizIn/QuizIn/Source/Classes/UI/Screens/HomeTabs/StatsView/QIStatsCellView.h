
#import <UIKit/UIKit.h>

@interface QIStatsCellView : UITableViewCell

@property (nonatomic,strong) NSString *connectionName;
@property (nonatomic,strong) NSString *rightAnswers;
@property (nonatomic,strong) NSString *wrongAnswers;
@property (nonatomic,assign) BOOL upTrend;
@property (nonatomic,assign) NSInteger keyColorIndex; 
@property (nonatomic,strong) NSURL *profileImageURL;

@end
