#import <Foundation/Foundation.h>

typedef void (^QICompaniesResult)(NSArray *companies, NSError *error);


@interface QILICompanies : NSObject

+ (void)getCompaniesWithIDs:(NSArray *)companyIDs
              fieldSelector:(NSString *)fieldSelector
               onCompletion:(QICompaniesResult)onCompletion;

@end
