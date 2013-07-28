#import "QICalendarData.h"
#import <EventKit/EventKit.h>

#define USE_TEST_DATA @YES
#define INTERVAL_TO_GRAB 604800.0 //A week

@implementation QICalendarData

+ (NSMutableArray *)getCalendarDataWithIntervalIndex:(NSInteger)dateIndex withEventStore:(EKEventStore *)eventStore{
    
  if (USE_TEST_DATA){
    NSMutableArray *calendarData = [[self grabTestData] mutableCopy];
    DDLogInfo(@"%d",dateIndex);
    return calendarData;
  }
  else {
    NSMutableArray *calendarData = [NSMutableArray  array];
    NSDate *startDate = [[NSDate alloc] dateByAddingTimeInterval:INTERVAL_TO_GRAB*dateIndex];
    NSDate *endDate = [[NSDate alloc] dateByAddingTimeInterval:INTERVAL_TO_GRAB*(dateIndex+1)];
    NSPredicate *dateRange = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:[eventStore calendarsForEntityType:EKEntityTypeEvent]];
    NSArray *events = [eventStore eventsMatchingPredicate:dateRange];
    EKEvent *event = [events objectAtIndex:0];
    // Time - event.startDate
    // Attendees - event.attendees
    // Title - event.title
    // Location - event.location
    return calendarData; 
  }
}

+ (NSMutableArray *)grabTestData{
  NSMutableArray *testData = [NSMutableArray array];
  NSMutableArray *testDay1 = [NSMutableArray array];
  NSMutableArray *testDay2 = [NSMutableArray array];
  NSArray *imageURLs = @[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                         [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                         [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"],
                         [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/080/035/28eea75.jpg"],
                         [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                         [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                         [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"]];
  NSArray *imageURLs3 =  @[[NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/3/000/00d/248/1c9f8fa.jpg"],
                           [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/6/000/1f0/39b/3ae80b5.jpg"],
                           [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/mpr/mpr/shrink_200_200/p/1/000/095/3e4/142853e.jpg"]];

  
  NSMutableDictionary *testMeeting1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"1:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 1", @"title",
                                       @"Meeting Location 1", @"location",
                                       imageURLs, @"images",
                                       @NO,@"selected", nil];
  NSMutableDictionary *testMeeting2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"2:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 2", @"title",
                                       @"Meeting Location 2", @"location",
                                       imageURLs3, @"images",
                                       @YES, @"selected", nil];
  NSMutableDictionary *testMeeting3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"3:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 3", @"title",
                                       @"Meeting Location 3", @"location",
                                       imageURLs3, @"images",
                                       @NO, @"selected",nil];
  NSMutableDictionary *testMeeting4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"4:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 4", @"title",
                                       @"Meeting Location 4", @"location",
                                       imageURLs, @"images",
                                       @NO, @"selected",nil];
  NSMutableDictionary *testMeeting5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"5:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 5", @"title",
                                       @"Meeting Location 5", @"location",
                                       imageURLs3, @"images",
                                       @NO, @"selected",nil];
  [testDay1 addObjectsFromArray:@[@"Today",testMeeting1,testMeeting2]];
  [testDay2 addObjectsFromArray:@[@"Tomorrow",testMeeting3,testMeeting4,testMeeting5]];
  [testData addObjectsFromArray:@[testDay1,testDay2]];

  return [testData copy];
}

@end
