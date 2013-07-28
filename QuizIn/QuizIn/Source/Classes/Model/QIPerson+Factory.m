#import "QIPerson+Factory.h"

@implementation QIPerson (Factory)

+ (QIPerson *)personWithJSON:(NSDictionary *)personJSON {
  QIPerson *person = [QIPerson new];
  person.personID = personJSON[@"id"];
  person.firstName = personJSON[@"firstName"];
  person.lastName = personJSON[@"lastName"];
  person.formattedName = personJSON[@"formattedName"];
  person.industry = personJSON[@"industry"];
  person.pictureURL = personJSON[@"pictureUrl"];
  person.publicProfileURL = personJSON[@"publicProfileUrl"];
  if (personJSON[@"numConnections"] != nil) {
    person.numberOfConnections = [personJSON[@"numConnections"] integerValue];
  } else {
    person.numberOfConnections = -1;
  }
  return person;
}

@end
