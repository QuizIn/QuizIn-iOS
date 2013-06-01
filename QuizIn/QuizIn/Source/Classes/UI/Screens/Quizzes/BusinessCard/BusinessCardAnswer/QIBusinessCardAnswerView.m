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
@property(nonatomic, strong) UILabel *answer;
@property(nonatomic, strong) UILabel *answer1;
@property(nonatomic, strong) UILabel *answer2;
@property(nonatomic, strong) NSArray *spacers;

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
    _answer = [self newAnswer];
    _answer1 = [self newAnswer];
    _answer2 = [self newAnswer];
    _spacers = [self newSpacers];
    [self constructViewHierarchy];
  }
  return self;
}

#pragma mark Properties

- (void)setAnswers:(NSArray *)answers {
  if ([answers isEqualToArray:_answers]) {
    return;
  }
  _answers = [answers copy];
  [self updateAnswers];
}

#pragma mark View Hierarchy

- (void)constructViewHierarchy {
  [_answerScrollView addSubview:_answer];
  [_answerScrollView addSubview:_answer1];
  [_answerScrollView addSubview:_answer2];
  
  for (UIView *spacer in self.spacers){
    [_answerScrollView addSubview:spacer];
  }
  [self addSubview:self.answerScrollView];
  [self addSubview:self.answerHolder];
}

#pragma mark Layout

- (void)updateConstraints {
  [super updateConstraints];
  if (!self.answerViewConstraints){
    
    self.answerViewConstraints = [NSMutableArray array];
    
    NSDictionary *answerHolderConstraintViews  = [NSDictionary dictionaryWithObjectsAndKeys:
                                         _answerHolder,       @"_answerHolder",
                                         _answerScrollView,   @"_answerScrollView",
                                         _answer,             @"_answer",
                                         _answer1,            @"_answer1",
                                         _answer2,            @"_answer2",
                                         _spacers[0],         @"_spacers0",
                                         _spacers[1],         @"_spacers1",
                                         _spacers[2],         @"_spacers2",
                                         _spacers[3],         @"_spacers3",
                                         _spacers[4],         @"_spacers4",
                                         _spacers[5],         @"_spacers5",
                                         nil];
   // NSDictionary *answerHolderConstraintViews = NSDictionaryOfVariableBindings(_answerHolder,_answerScrollView,_answer,_answer1,_answer2);
    
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
    float widthMultiplier = 544.0f / 566.0f;
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
    
    NSLayoutConstraint *vAnswer =
    [NSLayoutConstraint constraintWithItem:_answer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswer1 =
    [NSLayoutConstraint constraintWithItem:_answer1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];

    NSLayoutConstraint *vAnswer2 =
    [NSLayoutConstraint constraintWithItem:_answer2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswerHeight =
    [NSLayoutConstraint constraintWithItem:_answer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswer1Height =
    [NSLayoutConstraint constraintWithItem:_answer1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *vAnswer2Height =
    [NSLayoutConstraint constraintWithItem:_answer2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];

    float widthMultiplierLabels = 454.0f / 566.0f;
   
    NSLayoutConstraint *vAnswerWidth =
    [NSLayoutConstraint constraintWithItem:_answer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeWidth multiplier:widthMultiplierLabels constant:0.0f];
    
    NSLayoutConstraint *vAnswer1Width =
    [NSLayoutConstraint constraintWithItem:_answer1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeWidth multiplier:widthMultiplierLabels constant:0.0f];
    
    NSLayoutConstraint *vAnswer2Width =
    [NSLayoutConstraint constraintWithItem:_answer2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeWidth multiplier:widthMultiplierLabels constant:0.0f];

    [self.scrollViewConstraints addObjectsFromArray:@[vAnswerWidth,vAnswer1Width,vAnswer2Width]];
    
    float widthMultiplierSpacers = 57.0f / 566.0f;
    
    for (UIView *spacer in self.spacers){
      [self.scrollViewConstraints addObject:[NSLayoutConstraint constraintWithItem:spacer attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_answerScrollView attribute:NSLayoutAttributeWidth multiplier:widthMultiplierSpacers constant:0.0f]];
    }
  
    NSArray *hNames =
    [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_spacers0][_answer][_spacers1][_spacers2][_answer1][_spacers3][_spacers4][_answer2][_spacers5]|"
                                            options:NSLayoutFormatAlignAllTop
                                            metrics:nil
                                              views:answerHolderConstraintViews];
    
    [self.scrollViewConstraints addObjectsFromArray:@[vAnswer,vAnswer1,vAnswer2,vAnswerHeight,vAnswer1Height,vAnswer2Height]];
    [self.scrollViewConstraints addObjectsFromArray:hNames];
    
    [_answerScrollView addConstraints:self.scrollViewConstraints];
    [self addConstraints:self.answerViewConstraints];
  }
}

#pragma mark Actions
- (void)updateAnswers {
  if ([self.answers count] == 0) {
    return;
  }
  _answer.text = _answers[0];
  _answer1.text = _answers[1];
  _answer2.text = _answers[2];
}
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

-(UILabel *)newAnswer{
  UILabel *answer = [[UILabel alloc] init];
  [answer setTranslatesAutoresizingMaskIntoConstraints:NO];
  [answer setBackgroundColor:[UIColor clearColor]];
  [answer setFont:[QIFontProvider fontWithSize:20.0f style:Bold]];
  [answer setTextColor:[UIColor colorWithWhite:.33f alpha:1.0f]];
  
  //NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"trest" attributes:<#(NSDictionary *)#>
  [answer setAdjustsLetterSpacingToFitWidth:YES];
  [answer setAdjustsFontSizeToFitWidth:YES];
  [answer setMinimumScaleFactor:.8f];
  
  //[answer setAttributedText:string];
  //[answer setNumberOfLines:2];
  [answer setLineBreakMode:NSLineBreakByTruncatingMiddle];
  [answer setTextAlignment:NSTextAlignmentCenter];
  return answer;
}

-(NSArray *)newSpacers{
  NSMutableArray *spacerTemp= [[NSMutableArray alloc] init];
  for (int i=0;i<6;i++){
    UIView *spacerView = [[UIView alloc] init];
    [spacerView setBackgroundColor:[UIColor blackColor]];
    [spacerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [spacerTemp addObject:spacerView];
  }
  NSArray *spacers = [spacerTemp copy];
  return spacers;
}

@end