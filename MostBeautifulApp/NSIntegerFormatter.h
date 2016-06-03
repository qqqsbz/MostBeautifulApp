//
//  NSIntegerFormatter.h
//  iPenYou
//
//  Created by fanly frank on 6/8/15.
//  Copyright (c) 2015 vbuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIntegerFormatter : NSObject

+ (NSString *)formatToNSString:(NSInteger)value;

+ (NSString *)formatToNSString:(NSInteger)value fix:(BOOL)fix;

@end
