#import "QIQuizQuestion.h"

@class QIPerson;

@interface QIBusinessCardQuestion : QIQuizQuestion

@property(nonatomic, copy) QIPerson *person;
@property(nonatomic, copy) NSArray *names;
@property(nonatomic, assign) NSInteger correctNameIndex;
@property(nonatomic, copy) NSArray *companies;
@property(nonatomic, assign) NSInteger correctCompanyIndex;
@property(nonatomic, copy) NSArray *titles;
@property(nonatomic, assign) NSInteger correctTitleIndex;

@end
