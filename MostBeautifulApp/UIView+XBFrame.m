//
//  UIView+XBFrame.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "UIView+XBFrame.h"

@implementation UIView (XBFrame)
/**实现分类的方法 */
- (void)setXb_x:(CGFloat)xb_x
{
    CGRect rect = self.frame;
    rect.origin.x = xb_x;
    self.frame = rect;
}
- (CGFloat)xb_x
{
    return self.frame.origin.x;
}


- (void)setXb_y:(CGFloat)xb_y
{
    CGRect rect = self.frame;
    rect.origin.y = xb_y;
    self.frame = rect;
}
- (CGFloat)xb_y
{
    return self.frame.origin.y;
}


- (void)setXb_height:(CGFloat)xb_height
{
    CGRect rect = self.frame;
    rect.size.height = xb_height;
    self.frame = rect;
}
- (CGFloat)xb_height
{
    return self.frame.size.height;
}


- (void)setXb_width:(CGFloat)xb_width
{
    CGRect rect = self.frame;
    rect.size.width = xb_width;
    self.frame = rect;
}
- (CGFloat)xb_width
{
    return self.frame.size.width;
}

- (CGFloat)xb_centerX
{
    return self.center.x;
}

- (void)setXb_centerX:(CGFloat)xb_centerX{
    CGPoint center = self.center;
    center.x = xb_centerX;
    self.center = center;
}

- (CGFloat)xb_centerY
{
    return self.center.y;
}

- (void)setXb_centerY:(CGFloat)xb_centerY
{
    CGPoint center = self.center;
    center.y = xb_centerY;
    self.center = center;
}

@end
