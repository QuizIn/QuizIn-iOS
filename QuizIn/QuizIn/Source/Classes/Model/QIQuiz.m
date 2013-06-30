#import "QIQuiz.h"

#import "QIMultipleChoiceQuestion.h"
#import "QIPerson.h"

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
  for (QIMultipleChoiceQuestion *question in self.questions) {
    if (question.person.pictureURL != nil) {
      return question;
    }
  }
  return self.questions[0];
}

@end
