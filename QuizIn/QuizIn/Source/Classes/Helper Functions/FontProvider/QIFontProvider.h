//
//  QIFontProvider.h
//  QuizIn
//
//  Created by Rick Kuhlman on 5/27/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QIFontProvider : NSObject

typedef enum FontStyle: NSInteger FontStyle;
enum FontStyle : NSInteger {
  Regular,
  Bold,
  Italics
};

+ (UIFont *)fontWithSize:(float)size style:(FontStyle)fontStyle;

@end
