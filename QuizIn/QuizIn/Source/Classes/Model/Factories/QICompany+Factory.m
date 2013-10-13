#import "QICompany+Factory.h"

@implementation QICompany (Factory)

+ (QICompany *)companyWithJSON:(NSDictionary *)companyJSON {
  QICompany *company = [QICompany new];
  company.companyID = companyJSON[@"id"];
  company.industry = companyJSON[@"industry"];
  company.name = companyJSON[@"name"];
  company.size = companyJSON[@"size"];
  company.ticker = companyJSON[@"ticker"];
  company.type = companyJSON[@"type"];
  return company;
}

@end
