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

@property (assign, nonatomic) BOOL  isBecomeFirstResponder;

@property (strong, nonatomic) NSString  *placeHolderString;

- (instancetype)initWidthSearchBlock:(SearchBlock)searchBlock cancleBlock:(dispatch_block_t)block;

- (instancetype)initWithFrame:(CGRect)frame searchBlock:(SearchBlock)searchBlock cancleBlock:(dispatch_block_t)block;

- (void)startAnimation;

- (void)stopAnimation;

@end
