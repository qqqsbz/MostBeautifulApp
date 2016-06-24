//
//  NSString+Util.m
//  iPenYou
//
//  Created by coder on 16/3/17.
//  Copyright © 2016年 vbuy. All rights reserved.
//

#import "NSString+Util.h"
@implementation NSString (Util)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dic = @{NSFontAttributeName:font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
}


- (NSString *)urlEncodedString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(
                               CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                               (CFStringRef)self,
                               (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                               NULL,
                               kCFStringEncodingUTF8));
    return encodedString;
}

@end
