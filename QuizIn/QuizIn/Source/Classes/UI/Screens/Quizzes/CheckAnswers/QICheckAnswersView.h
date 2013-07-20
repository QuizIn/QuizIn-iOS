//
//  QICheckAnswersView.h
//  QuizIn
//
//  Created by Rick Kuhlman on 6/30/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QICheckAnswersView : UIView

@property(nonatomic, strong,readonly) UIButton *checkButton;
@property(nonatomic, strong,readonly) UIButton *helpButton;
@property(nonatomic, strong,readonly) UIButton *nextButton;
@property(nonatomic, strong,readonly) UIButton *againButton;
@property(nonatomic, strong,readonly) UIButton *resultHideButton;


-(void)correct:(BOOL)correct;

@end



