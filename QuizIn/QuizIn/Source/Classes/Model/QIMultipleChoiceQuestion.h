#import "QIQuizQuestion.h"

@class QIPerson;

@interface QIMultipleChoiceQuestion : QIQuizQuestion

@property(nonatomic, copy) QIPerson *person;
@property(nonatomic, copy) NSString *questionPrompt;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, assign) NSUInteger correctAnswerIndex;

@end
