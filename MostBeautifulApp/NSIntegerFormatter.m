//
//  NSIntegerFormatter.m
//  iPenYou
//
//  Created by fanly frank on 6/8/15.
//  Copyright (c) 2015 vbuy. All rights reserved.
//

#import "NSIntegerFormatter.h"

@implementation NSIntegerFormatter

+ (NSString *)formatToNSString:(NSInteger)value {
    NSString *result;
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    result = [NSString stringWithFormat:@"%ld", value];
#else
    result = [NSString stringWithFormat:@"%d", value];
#endif
    return result;
}

+ (NSString *)formatToNSString:(NSInteger)value fix:(BOOL)fix
{
    NSString *result;
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    result = [NSString stringWithFormat:@"%02ld", value];
#else
    result = [NSString stringWithFormat:@"%02d", value];
#endif
    return result;
}

@end
