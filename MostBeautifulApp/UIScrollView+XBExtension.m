//
//  UIScrollView+XBExtension.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "UIScrollView+XBExtension.h"

@implementation UIScrollView (XBExtension)

- (void)setXb_contentInsetTop:(CGFloat)xb_contentInsetTop
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = xb_contentInsetTop;
    self.contentInset = inset;
}

- (CGFloat)xb_contentInsetTop
{
    return self.contentInset.top;
}

- (void)setXb_contentInsetBottom:(CGFloat)xb_contentInsetBottom
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = xb_contentInsetBottom;
    self.contentInset = inset;
}

- (CGFloat)xb_contentInsetBottom
{
    return self.contentInset.bottom;
}

- (void)setXb_contentInsetLeft:(CGFloat)xb_contentInsetLeft
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = xb_contentInsetLeft;
    self.contentInset = inset;
}

- (CGFloat)xb_contentInsetLeft
{
    return self.contentInset.left;
}

- (void)setXb_contentInsetRight:(CGFloat)xb_contentInsetRight
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = xb_contentInsetRight;
    self.contentInset = inset;
}

- (CGFloat)xb_contentInsetRight
{
    return self.contentInset.right;
}

- (void)setXb_contentOffsetX:(CGFloat)xb_contentOffsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = xb_contentOffsetX;
    self.contentOffset = offset;
}

- (CGFloat)xb_contentOffsetX
{
    return self.contentOffset.x;
}

- (void)setXb_contentOffsetY:(CGFloat)xb_contentOffsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = xb_contentOffsetY;
    self.contentOffset = offset;
}

- (CGFloat)xb_contentOffsetY
{
    return self.contentOffset.y;
}

- (void)setXb_contentSizeWidth:(CGFloat)xb_contentSizeWidth
{
    CGSize size = self.contentSize;
    size.width = xb_contentSizeWidth;
    self.contentSize = size;
}

- (CGFloat)xb_contentSizeWidth
{
    return self.contentSize.width;
}

- (void)setXb_contentSizeHeight:(CGFloat)xb_contentSizeHeight
{
    CGSize size = self.contentSize;
    size.height = xb_contentSizeHeight;
    self.contentSize = size;
}

- (CGFloat)xb_contentSizeHeight
{
    return self.contentSize.height;
}

@end
