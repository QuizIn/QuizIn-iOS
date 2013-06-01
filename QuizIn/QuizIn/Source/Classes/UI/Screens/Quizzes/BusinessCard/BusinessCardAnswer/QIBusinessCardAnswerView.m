//
//  QIBusinessCardAnswerView.m
//  QuizIn
//
//  Created by Rick Kuhlman on 5/27/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import "QIBusinessCardAnswerView.h"
#import "QIFontProvider.h"

@interface QIBusinessCardAnswerView ()

@property(nonatomic, strong) UIImageView *answerHolder;
@property(nonatomic, strong) UIScrollView *answerScrollView;
@property(nonatomic, strong) UILabel *answers;
@property(nonatomic, strong) UILabel *answers1;
@property(nonatomic, strong) UILabel *answers2;
@property(nonatomic, strong) NSMutableArray *answerViewConstraints;
@property(nonatomic, strong) NSMutableArray *scrollViewConstraints;

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
    _answerScrollView = [self newAnswerScrollView];
    _answers = [self newAnswers];
    _answers1 = [self newAnswers];
    _answers2 = [self newAnswers];
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
  [_answerScrollView addSubview:_answers];
  [_answerScrollView addSubview:_answers1];
  [_answerScrollView addSubview:_answers2];
  [self addSubview:self.answerScrollView];
  [self addSubview:self.answerHolder];
  
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.answerViewConstraints){
    
    self.answerViewConstraints = [NSMutableArray array];
    NSDictionary *answerHolderConstraintViews = NSDictionaryOfVariableBindings(_answerHolder,_answerScrollView,_answers,_answers1,_answers2);
    
    //Constrain answer holder image
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
    
    //Constrain answer Scroll View
    float widthMultiplier = 546.0f / 566.0f;
    float heightMultiplier = 96.0f / 136.0f;
    
    NSLayoutConstraint *widthScrollView =
    [NSLayoutConstraint constraintWithItem:_answerScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_answerHolder attribute:NSLayoutAttributeWidth multiplier:widthMultiplier constant:0];
    
    NSLayoutConstraint *heightScrollView =
    [NSLayoutConstraint constraintWithItem:_answerScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_answerHolder attribute:NSLayoutAttributeHeight multiplier:heightMultiplier constant:0];
    
    NSLayoutConstraint *centerXScrollView =
    [NSLayoutConstraint constraintWithItem:_answerScrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_answerHolder attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    
    NSLayoutConstraint *centerYScrollView =
    [NSLayoutConstraint constraintWithItem:_answerScrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_answerHolder attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
    [self.answerViewConstraints addObjectsFromArray:@[widthScrollView,heightScrollView,centerXScrollView,centerYScrollView]];
    
    //Constrain Answers
    self.scrollViewConstraints = [NSMutableArray array];
    
    NSLayoutConstraint *vAnswers =
    [NSLayoutConstraint constraintWithItem:_answers attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswers1 =
    [NSLayoutConstraint constraintWithItem:_answers1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];

    NSLayoutConstraint *vAnswers2 =
    [NSLayoutConstraint constraintWithItem:_answers2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswersHeight =
    [NSLayoutConstraint constraintWithItem:_answers attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswers1Height =
    [NSLayoutConstraint constraintWithItem:_answers1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswers2Height =
    [NSLayoutConstraint constraintWithItem:_answers2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];

    NSArray *hNames =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_answers(==_answerScrollView)][_answers1(==_answers)][_answers2(==_answers)]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:answerHolderConstraintViews];
    
    [self.scrollViewConstraints addObjectsFromArray:@[vAnswers,vAnswers1,vAnswers2,vAnswersHeight,vAnswers1Height,vAnswers2Height]];
    [self.scrollViewConstraints addObjectsFromArray:hNames];
    
    [_answerScrollView addConstraints:self.scrollViewConstraints];
    
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

-(UIScrollView *)newAnswerScrollView{
  UIScrollView *answerView = [[UIScrollView alloc] init];
  [answerView setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.0f]];
  [answerView setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answerView setPagingEnabled:YES];
  [answerView setShowsHorizontalScrollIndicator:NO];
  [answerView setShowsVerticalScrollIndicator:NO];
  [answerView setBouncesZoom:NO];
  [answerView setBounces:YES];
  [answerView setDirectionalLockEnabled:YES];
  [answerView setAlwaysBounceVertical:NO];
  [answerView setAlwaysBounceHorizontal:YES];
  return answerView;
}

-(UILabel *)newAnswers{
  UILabel *answer = [[UILabel alloc] init];
  answer.text = @"Rick Kuhlman";
  [answer setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answer setBackgroundColor:[UIColor clearColor]];
  [answer setFont:[QIFontProvider fontWithSize:25.0f style:Regular]];
  [answer setTextColor:[UIColor colorWithWhite:.50f alpha:1.0f]];
  [answer setAdjustsLetterSpacingToFitWidth:YES];
  [answer setAdjustsFontSizeToFitWidth:YES];
  [answer setMinimumScaleFactor:.8f];
  [answer setLineBreakMode:NSLineBreakByTruncatingMiddle];
  [answer setTextAlignment:NSTextAlignmentCenter];
  return answer;
}

@end