//
//  QICalendarCellView.h
//  QuizIn
//
//  Created by Rick Kuhlman on 6/16/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QICalendarCellView : UITableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic,strong) UILabel *meetingTitle;
@property (nonatomic,strong) UILabel *meetingLocation;
@property (nonatomic,strong) UILabel *meetingTime;
@property (nonatomic,strong) NSArray *imageURLs;

@end
