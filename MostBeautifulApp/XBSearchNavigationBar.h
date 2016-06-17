//
//  XBSearchNavigationBar.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)(NSString *text);
@interface XBSearchNavigationBar : UIView
/** 是否变成第一响应者 */
@property (assign, nonatomic) BOOL  isBecomeFirstResponder;
/** 当textfield的值发生变化时进行搜索 */
@property (assign, nonatomic) BOOL  isChangeSearch;
/** 设置placeholder */
@property (strong, nonatomic) NSString  *placeHolderString;


- (instancetype)initWidthSearchBlock:(SearchBlock)searchBlock cancleBlock:(dispatch_block_t)block;

- (instancetype)initWithFrame:(CGRect)frame searchBlock:(SearchBlock)searchBlock cancleBlock:(dispatch_block_t)block;

/** 左边开始动画 */
- (void)startAnimation;

/** 结束动画 */
- (void)stopAnimation;

@end
