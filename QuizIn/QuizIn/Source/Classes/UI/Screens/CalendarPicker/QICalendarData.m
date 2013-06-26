
#import "QICalendarData.h"
#import <EventKit/EventKit.h>


//Each Array Element Needs:

//Calendar Array
  //1
    //1
      //Date
    //2
      //Dictionary
        //Start Time
        //emails of participants
        //Meeting Title
        //Meeting Location
    //3
      //Dictionary
        //Stuff...

  //2
    //1
      //Date
    //2
      //Dictionary
      //Date as String


@implementation QICalendarData

+ (NSMutableArray *)getCalendarDataWithStartDate:(NSDate *)date withEventStore:(EKEventStore *)eventStore{
  //NSMutableArray *calendarData = [NSMutableArray  array];
  NSMutableArray *calendarData = [[self grabTestData] copy];
  return calendarData;
}

+ (NSMutableArray *)grabTestData{
  NSMutableArray *testData = [NSMutableArray array];
  NSMutableArray *testDay1 = [NSMutableArray array];
  NSMutableArray *testDay2 = [NSMutableArray array];
  NSMutableDictionary *testMeeting1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"1:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 1", @"title",
                                       @"Meeting Location 1", @"location",nil];
  NSMutableDictionary *testMeeting2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"2:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 2", @"title",
                                       @"Meeting Location 2", @"location",nil];
  NSMutableDictionary *testMeeting3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"3:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 3", @"title",
                                       @"Meeting Location 3", @"location",nil];
  NSMutableDictionary *testMeeting4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"4:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 4", @"title",
                                       @"Meeting Location 4", @"location",nil];
  NSMutableDictionary *testMeeting5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"5:35", @"time",
                                       @[@"rkuhlman@gmail.com",@"tim.dredge@gmail.com"],@"emails",
                                       @"Meeting Title 5", @"title",
                                       @"Meeting Location 5", @"location",nil];
  [testDay1 addObjectsFromArray:@[@"Today",testMeeting1,testMeeting2]];
  [testDay2 addObjectsFromArray:@[@"Tomorrow",testMeeting3,testMeeting4,testMeeting5]];
  [testData addObjectsFromArray:@[testDay1,testDay2]];

  return [testData copy];
}

@end
