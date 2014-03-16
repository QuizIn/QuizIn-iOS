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

- (QICheckAnswersView *)checkAnswersView {
  return (QICheckAnswersView *)[self.view valueForKey:@"checkAnswersView"];
}

- (QIRankDisplayView *)rankDisplayView {
  @try {
    return (QIRankDisplayView *)[self.view valueForKey:@"rankDisplayView"];
  }
  @catch (NSException *exception) {
    return nil;
  }
  @finally {
    NULL;
  }
}

- (void)didCheckAnswerIsCorrect:(BOOL)isCorrect sender:(id)sender {
  self.isCorrect = isCorrect;
}

- (QIProgressView *)progressView {
  return (QIProgressView *)[self.view valueForKey:@"progressView"];
}

@end
