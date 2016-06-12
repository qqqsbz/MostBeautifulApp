//
//  XBLeftHeaderView.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface XBLeftHeaderView : UIView

@property (strong, nonatomic) User  *user;

- (instancetype)initWithFrame:(CGRect)frame loginBlock:(dispatch_block_t)block;

@end
