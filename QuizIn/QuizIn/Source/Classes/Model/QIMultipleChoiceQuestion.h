#import "QIQuizQuestion.h"

@class QIPerson;
@class QIConnectionsStore;

@interface QIMultipleChoiceQuestion : QIQuizQuestion

@property(nonatomic, copy) QIPerson *person;
@property(nonatomic, copy) NSString *questionPrompt;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, assign) NSUInteger correctAnswerIndex;

+ (instancetype)multipleChoiceQuestionForPersonID:(NSString *)personID
                                 connectionsStore:(QIConnectionsStore *)connections;

@end
