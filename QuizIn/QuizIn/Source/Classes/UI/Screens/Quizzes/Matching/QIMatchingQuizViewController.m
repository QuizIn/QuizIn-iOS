//
//  QIMatchingQuizViewController.m
//  QuizIn
//
//  Created by Rick Kuhlman on 5/18/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import "QIMatchingQuizViewController.h"

@interface QIMatchingQuizViewController ()

@end

@implementation QIMatchingQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView{
  self.view = [[QIMatchingQuizView alloc] init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.matchingQuizView.numberOfQuestions = 10;
  self.matchingQuizView.quizProgress = 4;
  self.matchingQuizView.questionImageURLs = @[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                                              [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                                              [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"],
                                              [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/080/035/28eea75.jpg"]];
  self.matchingQuizView.answers = @[@"Knoxville Fellows",@"Invodo",@"Mutual Mobile",@"Google"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QIMatchingQuizView *)matchingQuizView {
  return (QIMatchingQuizView *)self.view;
}

@end
