#import <Foundation/Foundation.h>

@class QIConnectionsStore;

@interface QIQuizQuestion : NSObject

+ (instancetype)newRandomQuestionForPersonID:(NSString *)personID
                            connectionsStore:(QIConnectionsStore *)connections;

@end
