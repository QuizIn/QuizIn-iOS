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
  self.matchingQuizView.questions = @[@"Rick Kuhlman",@"Rene Cacheaux",@"Tim Dredge",@"George Bush"];
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
