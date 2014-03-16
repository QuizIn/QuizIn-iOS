#import <Foundation/Foundation.h>

@protocol QIQuizQuestionViewInteractor <NSObject>

- (void)didCheckAnswerIsCorrect:(BOOL)isCorrect sender:(id)sender;

@end
