//
//  XBSettingFooterView.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kFooterH   80.f
#import <UIKit/UIKit.h>

@interface XBSettingFooterView : UIView

- (instancetype)initDidSelectedLoginOutBlock:(dispatch_block_t)block;

- (instancetype)initWithFrame:(CGRect)frame didSelectedLoginOutBlock:(dispatch_block_t)block;

@end
