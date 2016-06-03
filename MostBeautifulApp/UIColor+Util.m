//
//  UIColor+Util.m
//  iPenYou
//
//  Created by trgoofi on 14-8-28.
//  Copyright (c) 2014年 vbuy. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

+ (UIColor *)colorWithHex:(UInt32)hex
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hex & 0x00FF00) >> 8)) / 255.0
                            blue:((float)((hex & 0x0000FF))) / 255.0
                           alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString;
{
    if (![hexString hasPrefix:@"#"] && [hexString length] != 7) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                reason:[NSString stringWithFormat:@"Could not parse string: %@", hexString]
                               userInfo:nil] raise];;
    }
    UInt32 hex;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&hex];
    return [self colorWithHex:hex];
}

@end
