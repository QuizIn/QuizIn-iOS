#import "QICompany+Factory.h"

@implementation QICompany (Factory)

+ (QICompany *)companyWithJSON:(NSDictionary *)companyJSON {
  QICompany *company = [QICompany new];
  company.companyID = companyJSON[@"id"];
  company.name = companyJSON[@"name"];
  company.ticker = companyJSON[@"ticker"];
  
  company.websiteURLString = companyJSON[@"websiteUrl"];
  company.logoURLString = companyJSON[@"logoUrl"];
  company.squareLogoURLString = companyJSON[@"squareLogoUrl"];
  company.foundedYear = companyJSON[@"foundedYear"];
  company.companyDescription = companyJSON[@"description"];
  
  if (companyJSON[@"type"]) {
    company.type = companyJSON[@"type"];
  }
  if (companyJSON[@"size"]) {
    company.size = companyJSON[@"size"];
  }
  if (companyJSON[@"industry"]) {
    company.industry = companyJSON[@"industry"];
  }
  
  if (companyJSON[@"companyType"]) {
    company.type = companyJSON[@"companyType"][@"name"];
  }
  if (companyJSON[@"employeeCountRange"]) {
    company.size = companyJSON[@"employeeCountRange"][@"name"];
  }
  if (companyJSON[@"industries"]) {
    NSArray *industriesJSON = companyJSON[@"industries"][@"values"];
    if (industriesJSON && [industriesJSON count] > 0) {
      company.industry = industriesJSON[0][@"name"];
    }
  }
  
  if (companyJSON[@"locations"]) {
    NSArray *locationsJSON = companyJSON[@"locations"][@"values"];
    if (locationsJSON && [locationsJSON count] > 0) {
      for (NSDictionary *locationJSON in locationsJSON) {
        if ([locationJSON[@"isHeadquarters"] isEqual:@(1)]) {
          company.headquarterLocationDescription = locationJSON[@"address"][@"city"];
        }
      }
      if (!company.headquarterLocationDescription) {
        company.headquarterLocationDescription = locationsJSON[0][@"address"][@"city"];
      }
    }
  }
  
  return company;
}

@end
