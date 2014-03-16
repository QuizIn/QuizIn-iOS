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
  company.websiteURLString = [self.websiteURLString copy];
  company.logoURLString = [self.logoURLString copy];
  company.squareLogoURLString = [self.squareLogoURLString copy];
  company.companyDescription = [self.companyDescription copy];
  company.foundedYear = [self.foundedYear copy];
  company.headquarterLocationDescription = [self.headquarterLocationDescription copy];
  
  return company;
}

- (NSString *)description {
  NSMutableString *description = [[super description] mutableCopy];
  
  [description appendFormat:@" name:%@ ", self.name];
  
  return [description copy];
}

@end
