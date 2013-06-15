#import <UIKit/UIKit.h>
#import "QIProgressView.h"

@interface QIMatchingQuizView : UIView

@property(nonatomic, strong) QIProgressView *progressView;
@property(nonatomic, assign) NSUInteger quizProgress;
@property(nonatomic, assign) NSUInteger numberOfQuestions;

@property(nonatomic, copy) NSArray *questionImageURLs;
@property(nonatomic, copy) NSArray *answers;


@end
