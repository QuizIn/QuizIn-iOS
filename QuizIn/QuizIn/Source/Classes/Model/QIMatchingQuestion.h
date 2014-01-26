#import "QIQuizQuestion.h"

@class QIConnectionsStore;

@interface QIMatchingQuestion : QIQuizQuestion

@property(nonatomic, copy) NSArray *people;
@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, copy) NSArray *correctAnswers;

+ (instancetype)matchingQuestionForPersonID:(NSString *)personID
                           connectionsStore:(QIConnectionsStore *)connections;

@end
