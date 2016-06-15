//
//  XBRefreshHeader.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRefreshHeader.h"
@interface XBRefreshHeader()
@end
@implementation XBRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(XBRefreshComponentRefreshingBlock)refreshingBlock
{
    XBRefreshHeader *refreshHeader = [[self alloc] init];
    refreshHeader.refreshingBlock  = refreshingBlock;
    return refreshHeader;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

/** 调整控件位置 */
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    
    // 设置高度
    self.xb_height = newSuperview.xb_height;
    self.xb_width  = kXBRefreshHeaderWidth;
    // 设置位置
    self.xb_x = -kXBRefreshHeaderWidth;
    
    //设置位置
    self.pullingImageView.center = CGPointMake(kXBRefreshHeaderWidth * 0.6, self.xb_centerY);
    
    self.loadingImageView.xb_centerY = self.xb_centerY;
}

/**
 * 根据状态做相应处理
 */
- (void)setState:(XBRefreshState)state
{
    if (self.state == state && self.state == XBRefreshStateRefreshing) return;
    
    super.state = state;
    
    switch (state) {
        case XBRefreshStateNormal:
        {
            self.pullingImageView.alpha = 1.f;
            self.loadingImageView.alpha = 0;
            [self.loadingImageView stopAnimating];
        }
            break;
        case XBRefreshStatePulling:
        {
            CGFloat currentOffsetX = self.scrollView.xb_contentOffsetX;
            NSInteger index = labs([[NSString stringWithFormat:@"%f",currentOffsetX] integerValue]) % (self.images.count);
            self.pullingImageView.image = [self.images objectAtIndex:index];
        }
            break;
        case XBRefreshStateRefreshing:
        {
            CGRect loadingFrame = self.loadingImageView.frame;
            self.loadingImageView.frame = self.pullingImageView.frame;
            [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.loadingImageView.frame = loadingFrame;
                self.loadingImageView.alpha = 1.f;
            } completion:^(BOOL finished) {
                [self.loadingImageView startAnimating];
                [self callBackHandler];
            }];
        }
            break;
        case XBRefreshStateWillRefreshing:
            break;
    }
}

/**
 * 开始执行动画
 */
- (void)beginRefreshing
{
    self.state = XBRefreshStateRefreshing;
    self.pullingImageView.alpha = 0.f;
}

/**
 * 结束动画
 */
- (void)endRefreshing
{
    self.state = XBRefreshStateNormal;
}

/**
 * 调用回调
 */
- (void)callBackHandler
{
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
}




@end
