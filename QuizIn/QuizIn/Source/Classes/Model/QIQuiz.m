#import "QIQuiz.h"

@interface QIQuiz ()
@property(nonatomic, copy) NSArray *questions;
@end

@implementation QIQuiz

+ (instancetype)quizWithQuestions:(NSArray *)questions {
  return [[self alloc] initWithQuestions:questions];
}

- (instancetype)initWithQuestions:(NSArray *)questions {
  self = [super init];
  if (self) {
    _questions = [questions copy];
  }
  return self;
}

- (instancetype)init {
  return [self initWithQuestions:@[]];
}

- (QIQuizQuestion *)nextQuestion {
  // TODO(Rene): Implement.
  return nil;
}

@end
