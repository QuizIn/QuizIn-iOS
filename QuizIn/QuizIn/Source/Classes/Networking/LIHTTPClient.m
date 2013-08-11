#import "LIHTTPClient.h"

#import <AuthKit/AKAccount.h>
#import <AFNetworking/AFJSONRequestOperation.h>

#import "AKGTMOAuth2Account.h"
#import "AKOAuth2AccountCredential.h"
#import "QIAccountStore.h"

@interface NSDictionary (LIQueryStringInspection)
- (BOOL)li_containsArray;
@end

@implementation NSDictionary (LIQueryStringInspection)
- (BOOL)li_containsArray {
  for (id key in self) {
    if ([self[key] isKindOfClass:[NSArray class]]) {
      return YES;
    }
  }
  return NO;
}
@end

static NSString * const kAFLinkedInAPIBaseURLString = @"https://api.linkedin.com/v1/";

extern NSArray * AFQueryStringPairsFromKeyAndValue(NSString *key, id value);

NSArray * LIAFQueryStringPairsFromKeyAndValue(NSString *key, id value) {
  if ([value isKindOfClass:[NSArray class]]) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    NSArray *array = value;
    for (id nestedValue in array) {
      [mutableQueryStringComponents addObjectsFromArray:LIAFQueryStringPairsFromKeyAndValue(key, nestedValue)];
    }
    return mutableQueryStringComponents;
  }
  
  return AFQueryStringPairsFromKeyAndValue(key, value);
}

NSArray * LIAFQueryStringPairsFromDictionary(NSDictionary *dictionary) {
  return LIAFQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSString * LIAFQueryStringFromParametersWithEncoding(NSDictionary *parameters, NSStringEncoding stringEncoding) {
  NSMutableArray *mutablePairs = [NSMutableArray array];
  for (id pair in LIAFQueryStringPairsFromDictionary(parameters)) {
    NSString *encodedString;
    
    SEL encodedStringSel = @selector(URLEncodedStringValueWithEncoding:);
    NSInvocation *inv =
        [NSInvocation invocationWithMethodSignature:[pair methodSignatureForSelector:encodedStringSel]];
    [inv setSelector:encodedStringSel];
    [inv setTarget:pair];
    //arguments 0 and 1 are self and _cmd respectively, automatically set by NSInvocation
    [inv setArgument:&stringEncoding atIndex:2];
    [inv invoke];
    [inv getReturnValue:&encodedString];
    
    [mutablePairs addObject:encodedString];
  }
  return [mutablePairs componentsJoinedByString:@"&"];
}

@implementation LIHTTPClient

+ (instancetype)sharedClient {
  static LIHTTPClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient =
        [[LIHTTPClient alloc]
         initWithBaseURL:[NSURL URLWithString:kAFLinkedInAPIBaseURLString]];
  });
  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (!self) {
    return nil;
  }
  [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
  [self setDefaultHeader:@"x-li-format" value:@"json"];
  return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
  // Add OAuth Access Token to URL.
  NSMutableDictionary *linkedInParameters =
      [NSMutableDictionary dictionaryWithDictionary:parameters];
  AKGTMOAuth2Account *masterAccount =
      (AKGTMOAuth2Account *)[[QIAccountStore sharedStore] authenticatedAccount];
  [linkedInParameters setObject:masterAccount.OAuth2Credential.accessToken
                        forKey:@"oauth2_access_token"];
  
  // Get URL request.
  NSMutableURLRequest *urlRequest = [super requestWithMethod:method
                                                        path:path
                                                  parameters:[linkedInParameters copy]];
  
  // Handle repeating query string parameters.
  if (linkedInParameters && [linkedInParameters li_containsArray]) {
    if ([method isEqualToString:@"GET"] ||
        [method isEqualToString:@"HEAD"] ||
        [method isEqualToString:@"DELETE"]) {
      NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
      NSString *queryStringFormat =
          [path rangeOfString:@"?"].location == NSNotFound ?@"?%@" : @"&%@";
      NSString *queryParameters =
          LIAFQueryStringFromParametersWithEncoding([linkedInParameters copy],self.stringEncoding);
      NSString *urlString =
          [[url absoluteString] stringByAppendingFormat:queryStringFormat, queryParameters];
      urlRequest.URL = [NSURL URLWithString:urlString];
    }
  }
  
  return urlRequest;
}

@end
