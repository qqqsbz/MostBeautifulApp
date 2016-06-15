//
//  XBRefreshFooter.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRefreshFooter.h"

@implementation XBRefreshFooter

+ (instancetype)footerWithRefreshingBlock:(XBRefreshComponentRefreshingBlock)refreshingBlock
{
    XBRefreshFooter *refreshFooter = [[self alloc] init];
    refreshFooter.refreshingBlock  = refreshingBlock;
    return refreshFooter;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:XBRefreshContentSize context:nil];
    
    if (newSuperview) { // 新的父控件
        // 监听
        [newSuperview addObserver:self forKeyPath:XBRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
    }
}

#pragma mark 重写调整frame
- (void)adjustFrameWithContentSize
{
    // 内容的高度
    CGFloat contentWidth = self.scrollView.xb_contentSizeWidth;
    // 表格的高度
    CGFloat scrollWidth = self.scrollView.xb_width;
    // 设置位置和尺寸
    self.xb_x = MAX(contentWidth, scrollWidth);
    
    // 设置高度
    self.xb_height = self.scrollView.xb_height;
    self.xb_width  = kXBRefreshHeaderWidth;
    
    //设置位置
    self.pullingImageView.center = CGPointMake(kXBRefreshHeaderWidth * 0.6, self.xb_centerY);
    
    
    self.loadingImageView.xb_x = contentWidth - kXBRefreshLoadingWH - kXBRefreshSpace;
    
}

#pragma mark 监听UIScrollView的属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互，直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    if ([XBRefreshContentSize isEqualToString:keyPath]) {
        // 调整frame
        [self adjustFrameWithContentSize];
    } else if ([XBRefreshContentOffset isEqualToString:keyPath]) {
        
        // 如果正在刷新，直接返回
        if (self.state == XBRefreshStateRefreshing) return;
        
        // 调整状态
        [self adjustStateWithContentOffset];
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    //当前的contentSize
    CGFloat currentSizeWidth = self.scrollView.xb_contentSizeWidth;
    // 当前的contentOffset
    CGFloat currentOffsetX = self.scrollView.xb_contentOffsetX + self.scrollView.xb_width;
    
    if (currentOffsetX < currentSizeWidth || currentSizeWidth <= 0) return;
    
    if (self.scrollView.isDragging && currentOffsetX > currentSizeWidth) {
        self.state = XBRefreshStatePulling;
    } else if (!self.scrollView.isDragging && currentOffsetX > currentSizeWidth) {
        self.state = XBRefreshStateRefreshing;
    }
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
            self.pullingImageView.alpha = 0.f;
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
