#import "QIQuizQuestionViewControllerFactory.h"

#import "QIMultipleChoiceQuestion.h"
#import "QIMultipleChoiceQuizViewController.h"
#import "QIBusinessCardQuestion.h"
#import "QIBusinessCardViewController.h"
#import "QIMatchingQuestion.h"
#import "QIMatchingQuizViewController.h"

@implementation QIQuizQuestionViewControllerFactory

+ (QIQuizQuestionViewController *)questionViewControllerForQuestion:(QIQuizQuestion *)question {
  if ([question isKindOfClass:[QIMultipleChoiceQuestion class]]) {
    return [[QIMatchingQuizViewController alloc] initWithQuestion:question];
  }
  if ([question isKindOfClass:[QIBusinessCardQuestion class]]) {
    return [[QIBusinessCardViewController alloc] initWithQuestion:question];
  }
  if ([question isKindOfClass:[QIMatchingQuestion class]]) {
    return [[QIMatchingQuizViewController alloc] initWithQuestion:question];
  }
  return nil;
}

@end
