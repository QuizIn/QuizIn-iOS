#import "QIGroupSelectionData.h"
#import <EventKit/EventKit.h>

#define USE_TEST_DATA @YES
#define INTERVAL_TO_GRAB 604800.0 //A week

@implementation QIGroupSelectionData

+ (NSMutableArray *)getSelectionData{
  NSMutableArray *testData = [NSMutableArray array];
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
  
  NSURL *logo1 = [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/media/p/2/000/01c/2c3/24f005d.png"];
  NSURL *logo2 = [NSURL URLWithString:@"http://m.c.lnkd.licdn.com/media/p/7/000/27f/0c0/2ea6b1f.png"];

  
  NSMutableDictionary *testSelection1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"123", @"contacts",
                                       @"National Instruments", @"title",
                                       @"Test Hardware and Software", @"subtitle",
                                       imageURLs, @"images",
                                       logo2, @"logo",
                                       @NO,@"selected", nil];
  NSMutableDictionary *testSelection2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"43", @"contacts",
                                       @"Selection Title 2", @"title",
                                       @"Selection subtitle 2", @"subtitle",
                                       imageURLs3, @"images",
                                       logo1, @"logo",
                                       @YES, @"selected", nil];
  NSMutableDictionary *testSelection3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"23", @"contacts",
                                       @"Selection Title 3", @"title",
                                       @"Selection subtitle 3", @"subtitle",
                                       imageURLs3, @"images",
                                       logo2, @"logo",
                                       @NO, @"selected",nil];
  NSMutableDictionary *testSelection4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"7", @"contacts",
                                       @"Selection Title 4", @"title",
                                       @"Selection subtitle 4", @"subtitle",
                                       imageURLs, @"images",
                                       logo1, @"logo",
                                       @NO, @"selected",nil];
  NSMutableDictionary *testSelection5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"2", @"contacts",
                                       @"Selection Title 5", @"title",
                                       @"Selection subtitle 5", @"subtitle",
                                       imageURLs3, @"images",
                                       logo2, @"logo",
                                       @NO, @"selected",nil];
  
  [testData addObjectsFromArray:@[testSelection1,testSelection2,testSelection3,testSelection4,testSelection5]];

  return [testData mutableCopy];
}

@end
