#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QIQuizQuestionType) {
  QIQuizQuestionTypeNone            = 0,
  QIQuizQuestionTypeMultipleChoice  = (1 << 0),
  QIQuizQuestionTypeMatching        = (1 << 1),
  QIQuizQuestionTypeBusinessCard    = (1 << 2),
};

typedef NS_ENUM(NSInteger, QIQuizQuestionAllowedTypes) {
  QIQuizQuestionAllowMultipleChoice   = 0,
  QIQuizQuestionAllowAll              = 1,
};


@class QIConnectionsStore;

@interface QIQuizQuestion : NSObject

+ (instancetype)newRandomQuestionForPersonID:(NSString *)personID
                            connectionsStore:(QIConnectionsStore *)connections
                               questionTypes:(QIQuizQuestionAllowedTypes)types;

@end
