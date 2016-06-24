//
//  NSString+Util.h
//  iPenYou
//
//  Created by coder on 16/3/17.
//  Copyright © 2016年 vbuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Util)

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//** 将含有中文的网址进行转码  */
- (NSString *)urlEncodedString;

@end
