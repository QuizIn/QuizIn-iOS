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
    
    NSArray *hScroller =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_answerScrollView]-|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:answerHolderConstraintViews];
    
    NSArray *vScroller =
    [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_answerScrollView]-15-|"
                                            options:NSLayoutFormatAlignAllCenterX
                                            metrics:nil
                                              views:answerHolderConstraintViews];
    
    NSArray *hNames =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_answers(==200)][_answers1(==_answers)][_answers2(==_answers)]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:answerHolderConstraintViews];
    
    [self.answerViewConstraints addObjectsFromArray:hAnswerHolder];
    [self.answerViewConstraints addObjectsFromArray:vAnswerHolder];
    [self.answerViewConstraints addObjectsFromArray:hScroller];
    [self.answerViewConstraints addObjectsFromArray:vScroller];
    [self.answerViewConstraints addObjectsFromArray:hNames];

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
  [answerView setContentSize:CGSizeMake(600,100)];
  [answerView setPagingEnabled:YES];
  [answerView setShowsHorizontalScrollIndicator:NO];
  return answerView;
}

-(UILabel *)newAnswers{
  UILabel *cardCompany = [[UILabel alloc] init];
  cardCompany.text = @"Rick Kuhlman";
  [cardCompany setTranslatesAutoresizingMaskIntoConstraints:NO];
  [cardCompany setBackgroundColor:[UIColor clearColor]];
  [cardCompany setFont:[QIFontProvider fontWithSize:14.0f style:Regular]];
  [cardCompany setTextColor:[UIColor colorWithWhite:.50f alpha:1.0f]];
  [cardCompany setAdjustsLetterSpacingToFitWidth:YES];
  [cardCompany setAdjustsFontSizeToFitWidth:YES];
  [cardCompany setMinimumScaleFactor:.8f];
  [cardCompany setLineBreakMode:NSLineBreakByTruncatingMiddle];
  return cardCompany;
}

@end