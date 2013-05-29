//
//  QIFontProvider.m
//  QuizIn
//
//  Created by Rick Kuhlman on 5/27/13.
//  Copyright (c) 2013 Kuhlmanation LLC. All rights reserved.
//

#import "QIFontProvider.h"

@implementation QIFontProvider

+ (UIFont *)fontWithSize:(float)size style:(FontStyle)fontStyle
{
  switch (fontStyle) {
    case Regular:
      return [UIFont fontWithName:@"Tahoma" size:size];
      break;
    case Bold:
      return [UIFont fontWithName:@"Tahoma-Bold" size:size];
      break;
    case Italics:
      return [UIFont fontWithName:@"Tahoma-FauxItalic" size:size];
      break;
    default:
      return [UIFont fontWithName:@"Tahoma" size:size];
      break;
  }
}

@end
