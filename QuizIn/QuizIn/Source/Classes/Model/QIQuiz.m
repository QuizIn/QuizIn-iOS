#import "QIQuiz.h"

#import "QIMultipleChoiceQuestion.h"
#import "QIPerson.h"

@interface QIQuiz ()
@property(nonatomic, assign, readwrite) NSInteger currentQuestionIndex;
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
    _currentQuestionIndex = 0;
  }
  return self;
}

- (instancetype)init {
  return [self initWithQuestions:@[]];
}

- (QIQuizQuestion *)nextQuestion {
  if (self.currentQuestionIndex >= [self.questions count]) {
    return nil;
  }
  return self.questions[self.currentQuestionIndex++];
}

@end
