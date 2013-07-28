#import "QIQuizQuestionViewController_Protected.h"

#import "QIQuizQuestion.h"

@interface QIQuizQuestionViewController ()

@end

@implementation QIQuizQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  return [self initWithQuestion:nil];
};

- (instancetype)initWithQuestion:(QIQuizQuestion *)question {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _question = question;
  }
  return self;
}

@end
