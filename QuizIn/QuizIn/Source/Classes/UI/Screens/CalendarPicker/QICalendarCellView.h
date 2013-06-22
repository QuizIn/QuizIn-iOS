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
@property (nonatomic,strong) NSString *meetingTitle;
@property (nonatomic,strong) NSString *meetingLocation;
@property (nonatomic,strong) NSString *meetingTime;
@property (nonatomic,strong) NSArray *imageURLs;

@end
