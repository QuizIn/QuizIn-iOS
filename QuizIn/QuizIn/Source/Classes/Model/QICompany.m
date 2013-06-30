#import "QICompany.h"

@implementation QICompany

- (id)copyWithZone:(NSZone *)zone {
  QICompany *company = [[[self class] allocWithZone:zone] init];
  
  company.companyID = [self.companyID copy];
  company.industry = [self.industry copy];
  company.name = [self.name copy];
  company.size = [self.size copy];
  company.ticker = [self.ticker copy];
  company.type = [self.type copy];
  
  return company;
}

- (NSString *)description {
  NSMutableString *description = [[super description] mutableCopy];
  
  [description appendFormat:@" name:%@ ", self.name];
  
  return [description copy];
}

@end
