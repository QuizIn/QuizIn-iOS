
#import <UIKit/UIKit.h>

@interface QIStatsCellView : UITableViewCell

@property (nonatomic,strong) NSString *connectionName;
@property (nonatomic,strong) NSString *rightAnswers;
@property (nonatomic,strong) NSString *wrongAnswers;
@property (nonatomic,strong) NSString *knowledgeIndex;
@property (nonatomic,strong) NSURL *profileImageURL;

@end
