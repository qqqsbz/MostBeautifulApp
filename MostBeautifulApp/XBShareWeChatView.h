//
//  XBShareWeChatView.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBShareWeChatView : UIView

- (instancetype)initWithDidSelectedBlock:(dispatch_block_t)block;

- (instancetype)initWithFrame:(CGRect)frame didSelectedBlock:(dispatch_block_t)block;

@end
