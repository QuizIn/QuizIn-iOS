#import "QIPosition+Factory.h"

@implementation QIPosition (Factory)

+ (QIPosition *)positionWithJSON:(NSDictionary *)positionJSON {
  QIPosition *position = [QIPosition new];
  position.positionID = positionJSON[@"id"];
  // TODO(Rene): Does JSON bool map to BOOL?
  position.isCurrent = [positionJSON[@"isCurrent"] boolValue];
  position.title = positionJSON[@"title"];
  
  NSDateComponents *dateComponents = [NSDateComponents new];
  [dateComponents setMonth:[positionJSON[@"startDate"][@"month"] intValue]];
  [dateComponents setYear:[positionJSON[@"startDate"][@"year"] intValue]];
  NSCalendar *gregorianCalendar =
  [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  position.startDate = [gregorianCalendar dateFromComponents:dateComponents];
  
  return position;
}

@end
