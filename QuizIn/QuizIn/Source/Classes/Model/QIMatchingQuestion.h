#import "QIQuizQuestion.h"

@interface QIMatchingQuestion : QIQuizQuestion

@property(nonatomic, copy) NSArray *people;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, copy) NSArray *correctAnswers;

@end
