//
//  QICalendarPickerViewController.m
//  QuizIn
//
//  Created by Rick Kuhlman on 6/15/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import "QICalendarPickerViewController.h"

@interface QICalendarPickerViewController ()

@end

@implementation QICalendarPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView{
  self.view = [[QICalendarPickerView alloc] init];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
