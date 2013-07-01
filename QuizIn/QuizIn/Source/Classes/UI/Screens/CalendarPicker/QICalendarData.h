//
//  QICalendarData.h
//  QuizIn
//
//  Created by Rick Kuhlman on 6/25/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface QICalendarData : NSObject

+ (NSMutableArray *)getCalendarDataWithIntervalIndex:(NSInteger)dateIndex withEventStore:(EKEventStore *)eventStore;

@end
