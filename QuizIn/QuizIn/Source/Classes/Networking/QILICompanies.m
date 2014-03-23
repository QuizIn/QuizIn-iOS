#import "QILICompanies.h"

#import "LIHTTPClient.h"
#import "QICompany.h"
#import "QICompany+Factory.h"

@implementation QILICompanies


+ (void)getCompaniesWithIDs:(NSArray *)companyIDs
              fieldSelector:(NSString *)fieldSelector
               onCompletion:(QICompaniesResult)onCompletion {
  NSString *companyIDsString = [companyIDs componentsJoinedByString:@","];
  [self getCompaniesWithIdentifierMixin:companyIDsString
                          fieldSelector:fieldSelector
                           onCompletion:onCompletion];
}

+ (void)getCompaniesWithIdentifierMixin:(NSString *)mixin
                          fieldSelector:(NSString *)fieldSelector
                           onCompletion:(QICompaniesResult)onCompletion {
  NSString *URISuffix = [NSString stringWithFormat:@"::(%@)", mixin];
  [self getCompaniesWithURISuffix:URISuffix fieldSelector:fieldSelector onCompletion:onCompletion];
}

+ (void)getCompaniesWithURISuffix:(NSString *)URISuffix
                    fieldSelector:(NSString *)fieldSelector
                     onCompletion:(QICompaniesResult)onCompletion {
  NSMutableString *resourcePath = [@"./companies" mutableCopy];
  
  if (URISuffix) {
    [resourcePath appendString:URISuffix];
  }
  if (fieldSelector) {
    [resourcePath appendFormat:@":(%@)", fieldSelector];
  }
  
  
  AFHTTPRequestOperationSuccess success = ^(NSURLSessionDataTask *task,
                                            NSDictionary *companiesResultJSON){
    NSLog(@"%@", companiesResultJSON);
    NSArray *companiesJSON = companiesResultJSON[@"values"];
    NSMutableArray *companies = [NSMutableArray arrayWithCapacity:[companiesJSON count]];
    for (NSDictionary *companyJSON in companiesJSON) {
      QICompany *company = [QICompany companyWithJSON:companyJSON];
      [companies addObject:company];
    }
    onCompletion ? onCompletion([companies copy], nil) : NULL;
  };
  
  AFHTTPRequestOperationFailure failure = ^(NSURLSessionDataTask *task,
                                            NSError *error){
    NSLog(@"%@", error);
    onCompletion ? onCompletion(nil, error) : NULL;
  };
  
  
  LIHTTPClient *client = [LIHTTPClient sharedClient];
  [client GET:[resourcePath copy] parameters:@{} success:success failure:failure];
}

@end
