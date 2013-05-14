#import "QIBusinessCardViewController.h"
#import "QIBusinessCardQuizView.h"

@interface QIBusinessCardViewController ()

@end

@implementation QIBusinessCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view = [[QIBusinessCardQuizView alloc] init];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
