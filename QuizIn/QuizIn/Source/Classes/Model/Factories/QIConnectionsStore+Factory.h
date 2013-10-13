#import "QIConnectionsStore.h"

@interface QIConnectionsStore (Factory)

+ (QIConnectionsStore *)storeWithJSON:(NSArray *)peopleJSON;

@end
