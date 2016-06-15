//
//  UIView+XBFrame.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XBFrame)
/** 在分类中@property只会生产方法的声明 */
@property (nonatomic, assign)CGFloat xb_height;
@property (nonatomic, assign)CGFloat xb_width;
@property (nonatomic, assign)CGFloat xb_x;
@property (nonatomic, assign)CGFloat xb_y;
@property (nonatomic, assign)CGFloat xb_centerX;
@property (nonatomic, assign)CGFloat xb_centerY;
@end
