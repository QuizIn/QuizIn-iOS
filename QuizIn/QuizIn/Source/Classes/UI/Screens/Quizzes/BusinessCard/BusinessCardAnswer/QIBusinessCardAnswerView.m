//
//  QIBusinessCardAnswerView.m
//  QuizIn
//
//  Created by Rick Kuhlman on 5/27/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import "QIBusinessCardAnswerView.h"

@interface QIBusinessCardAnswerView ()

@property(nonatomic, strong) UIImageView *answerHolder;
@property(nonatomic, strong) NSMutableArray *answerViewConstraints;

@end

@implementation QIBusinessCardAnswerView

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    _answerHolder = [self newAnswerHolder];
    //[self setBackgroundColor:[UIColor colorWithWhite:.90f alpha:1.0]];
    [self constructViewHierarchy];
  }
  return self;
}

#pragma mark Properties
/*
- (void)setQuizProgress:(NSUInteger)quizProgress {
  _quizProgress = quizProgress;
  [self updateProgress];
}
*/

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [self addSubview:self.answerHolder];
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.answerViewConstraints){
    
    self.answerViewConstraints = [NSMutableArray array];
    NSDictionary *answerHolderConstraintViews = NSDictionaryOfVariableBindings(_answerHolder);
    
    NSArray *hAnswerHolder =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_answerHolder]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:answerHolderConstraintViews];
    
    NSArray *vAnswerHolder =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_answerHolder]|"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:answerHolderConstraintViews];
    
    [self.answerViewConstraints addObjectsFromArray:hAnswerHolder];
    [self.answerViewConstraints addObjectsFromArray:vAnswerHolder];
    [self addConstraints:self.answerViewConstraints];
  }
}

#pragma mark Actions

#pragma mark Strings

#pragma mark Factory Methods

- (UIImageView *)newAnswerHolder {
  UIImageView *answerHolder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardquiz_answerholder"]];
  //TODO needs insets
  [answerHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
  return answerHolder;
}

@end