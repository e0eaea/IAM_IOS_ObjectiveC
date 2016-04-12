//
//  UIColor+Helper.m
//  Trost_iOS
//
//  Created by mac on 2015. 7. 23..
//  Copyright (c) 2015년 YoonChang KIM. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)

+ (UIColor *)colorWithRGBA:(NSUInteger)color {
    
    return [UIColor colorWithRed:((color >> 24) & 0xFF) / 255.0f
                           green:((color >> 16) & 0xFF) / 255.0f
                            blue:((color >> 8) & 0xFF) / 255.0f
                           alpha:((color) & 0xFF) / 255.0f];
}

@end
