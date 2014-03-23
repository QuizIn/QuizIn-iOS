#import "LIAuthenticatedRequestSerializer.h"

#import "AKGTMOAuth2Account.h"
#import "AKOAuth2AccountCredential.h"
#import "QIAccountStore.h"

NSString * const kLIAuthenticatedRequestSerializerParametersBodyKey = @"bodyJSON";

@implementation LIAuthenticatedRequestSerializer

+ (instancetype)serializer {
  return [self serializerWithWritingOptions:0];
}

+ (instancetype)serializerWithWritingOptions:(NSJSONWritingOptions)writingOptions {
  LIAuthenticatedRequestSerializer *serializer = [[self alloc] init];
  serializer.writingOptions = writingOptions;
  serializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", @"POST", @"PUT", nil];
  
  return serializer;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                     error:(NSError * __autoreleasing *)error {
  NSMutableDictionary *mutableParamters = [parameters mutableCopy];
  // Strip out body from parameters dictionary.
  id requestBodyJSON = parameters[kLIAuthenticatedRequestSerializerParametersBodyKey];
  [mutableParamters removeObjectForKey:kLIAuthenticatedRequestSerializerParametersBodyKey];
  // Add authentication credential.
  AKGTMOAuth2Account *masterAccount = (AKGTMOAuth2Account *)[[QIAccountStore sharedStore] authenticatedAccount];
  mutableParamters[@"oauth2_access_token"] = masterAccount.OAuth2Credential.accessToken;
  parameters = [mutableParamters copy];
  
  NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
  
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
  if (requestBodyJSON) {
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:requestBodyJSON options:self.writingOptions error:error]];
  }
  return request;
}

@end
