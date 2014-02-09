#import "QIConnectionsStore.h"

@interface QIConnectionsStore (Factory)

+ (QIConnectionsStore *)storeWithJSON:(NSArray *)peopleJSON;
+ (QIConnectionsStore *)storeWithPeople:(NSArray *)people;

@end
