//
//  UIScrollView+XBExtension.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (XBExtension)
@property (assign, nonatomic) CGFloat xb_contentInsetTop;
@property (assign, nonatomic) CGFloat xb_contentInsetBottom;
@property (assign, nonatomic) CGFloat xb_contentInsetLeft;
@property (assign, nonatomic) CGFloat xb_contentInsetRight;

@property (assign, nonatomic) CGFloat xb_contentOffsetX;
@property (assign, nonatomic) CGFloat xb_contentOffsetY;

@property (assign, nonatomic) CGFloat xb_contentSizeWidth;
@property (assign, nonatomic) CGFloat xb_contentSizeHeight;
@end
