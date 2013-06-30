#import <Foundation/Foundation.h>

@class QIQuizQuestion;

@interface QIQuiz : NSObject

@property(nonatomic, assign, readonly) NSInteger numberOfQuestions;
@property(nonatomic, assign, readonly) NSInteger currentQuestionIndex;

+ (instancetype)quizWithQuestions:(NSArray *)questions;
- (instancetype)initWithQuestions:(NSArray *)questions;
- (QIQuizQuestion *)nextQuestion;

@end
