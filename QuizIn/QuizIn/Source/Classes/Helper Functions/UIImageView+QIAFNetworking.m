#import "UIImageView+QIAFNetworking.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation UIImageView (QIAFNetworking)

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
  
  [self setImageWithURLRequest:request placeholderImage:placeholderImage success:success failure:failure];
}

@end
