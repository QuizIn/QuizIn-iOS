//
//  QIBusinessCardAnswerView.h
//  QuizIn
//
//  Created by Rick Kuhlman on 5/27/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

id delegate;
@interface QIBusinessCardAnswerView : UIView <UIScrollViewDelegate>

@property(nonatomic, copy) NSArray *answers;
@property(nonatomic, readonly)NSString *currentAnswer;

- (id)delegate;
- (void)setDelegate:(id)newDelegate;

@end


@protocol QIBusinessCardQuizViewDelegate <NSObject>

-(void)answerDidChange;

@end
