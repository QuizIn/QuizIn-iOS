#import "QIConnectionsStore+Factory.h"

#import "QIConnectionsStore.h"
#import "QIPerson.h"
#import "QIPerson+Factory.h"
#import "QILocation.h"
#import "QILocation+Factory.h"
#import "QIPosition.h"
#import "QIPosition+Factory.h"
#import "QICompany.h"
#import "QICompany+Factory.h"

@implementation QIConnectionsStore (Factory)

+ (QIConnectionsStore *)storeWithJSON:(NSArray *)peopleJSON {
  DDLogInfo(@"LinkedIn: Connections, %@", peopleJSON);
    
  QIConnectionsStore *connectionsStore = [QIConnectionsStore new];
  NSMutableDictionary *people = [NSMutableDictionary dictionaryWithCapacity:[peopleJSON count]];
  NSMutableSet *companyNames = [NSMutableSet set];
  NSMutableSet *industries = [NSMutableSet set];
  NSMutableSet *personNames = [NSMutableSet set];
  NSMutableSet *titleNames = [NSMutableSet set];
  NSMutableSet *cityNames = [NSMutableSet set];
  NSMutableSet *personIDsWithProfilePic = [NSMutableSet set];
  
  
  for (NSDictionary *personJSON in peopleJSON) {
    if ([personJSON[@"id"] isEqualToString:@"private"]) {
      continue;
    }
    QIPerson *person = [QIPerson personWithJSON:personJSON];
    [personNames addObject:[person.formattedName copy]];
    
    QILocation *location = [QILocation locationWithJSON:personJSON[@"location"]];
    [cityNames addObject:[location.name copy]];
    person.location = location;
    
    // TODO(Rene): Test if JSON has no positions in values.
    NSArray *positionsJSON = personJSON[@"positions"][@"values"];
    NSMutableSet *positions =
        [NSMutableSet setWithCapacity:[personJSON[@"positions"][@"_total"] intValue]];
    for (NSDictionary *positionJSON in positionsJSON) {
      QIPosition *position = [QIPosition positionWithJSON:positionJSON];
      NSDictionary *companyJSON = positionJSON[@"company"];
      QICompany *company = [QICompany companyWithJSON:companyJSON];
      position.company = company;
      
      [titleNames addObject:[position.title copy]];
      [industries addObject:[position.company.industry copy]];
      [companyNames addObject:[position.company.name copy]];
      [positions addObject:position];
    }
    person.positions = [positions copy];
  
    people[person.personID] = person;
    if (person.pictureURL != nil && [person.pictureURL length] > 0) {
      [personIDsWithProfilePic addObject:person.personID];
    }
  }
  
  connectionsStore.people = [people copy];
  connectionsStore.companyNames = [companyNames copy];
  connectionsStore.industries = [industries copy];
  connectionsStore.personNames = [personNames copy];
  connectionsStore.titleNames = [titleNames copy];
  connectionsStore.cityNames = [cityNames copy];
  connectionsStore.personIDsWithProfilePics = [personIDsWithProfilePic copy];
  return connectionsStore;
}

+ (QIConnectionsStore *)storeWithPeople:(NSArray *)people {
  QIConnectionsStore *connectionsStore = [QIConnectionsStore new];
  NSMutableDictionary *peopleMap = [NSMutableDictionary dictionaryWithCapacity:[people count]];
  NSMutableSet *companyNames = [NSMutableSet set];
  NSMutableSet *industries = [NSMutableSet set];
  NSMutableSet *personNames = [NSMutableSet set];
  NSMutableSet *titleNames = [NSMutableSet set];
  NSMutableSet *cityNames = [NSMutableSet set];
  NSMutableSet *personIDsWithProfilePic = [NSMutableSet set];
  
  
  for (QIPerson *person in people) {
    [personNames addObject:[person.formattedName copy]];
    [cityNames addObject:[person.location.name copy]];

    NSMutableSet *positions = [NSMutableSet setWithCapacity:[person.positions count]];
    for (QIPosition *position in person.positions) {
      [titleNames addObject:[position.title copy]];
      [industries addObject:[position.company.industry copy]];
      [companyNames addObject:[position.company.name copy]];
      [positions addObject:position];
    }
    
    peopleMap[person.personID] = person;
    if (person.pictureURL != nil && [person.pictureURL length] > 0) {
      [personIDsWithProfilePic addObject:person.personID];
    }
  }
  
  connectionsStore.people = [peopleMap copy];
  connectionsStore.companyNames = [companyNames copy];
  connectionsStore.industries = [industries copy];
  connectionsStore.personNames = [personNames copy];
  connectionsStore.titleNames = [titleNames copy];
  connectionsStore.cityNames = [cityNames copy];
  connectionsStore.personIDsWithProfilePics = [personIDsWithProfilePic copy];
  return connectionsStore;
}

@end
