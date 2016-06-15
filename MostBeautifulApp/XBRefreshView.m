//
//  XBRefreshView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRefreshView.h"
@implementation XBRefreshView

+ (instancetype)refreshWithRefreshingBlock:(XBRefreshComponentRefreshingBlock)refreshingBlock
{
    XBRefreshView *refreshHeader = [[self alloc] init];
    refreshHeader.refreshingBlock  = refreshingBlock;
    return refreshHeader;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.pullingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kXBRefreshLoadingWH, kXBRefreshLoadingWH)];
        [self addSubview:self.pullingImageView];
        
        self.loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kXBRefreshSpace, 0, kXBRefreshLoadingWH, kXBRefreshLoadingWH)];
        self.loadingImageView.animationDuration = 0.7f;
        self.loadingImageView.animationRepeatCount = NSIntegerMax;
        self.loadingImageView.alpha = 0;
    }
    return self;
}

#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    // 如果正在刷新，直接返回
    if (self.state == XBRefreshStateRefreshing) return;
    
    if ([XBRefreshContentOffset isEqualToString:keyPath]) {
        [self adjustStateWithContentOffset];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:XBRefreshContentOffset context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:XBRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置高度
        self.xb_height = newSuperview.xb_height;
        self.xb_width  = kXBRefreshHeaderWidth;
        // 设置位置
        self.xb_x = -kXBRefreshHeaderWidth;
        
        //设置位置
        self.pullingImageView.center = CGPointMake(kXBRefreshHeaderWidth * 0.6, self.xb_centerY);
        
        self.loadingImageView.xb_centerY = self.xb_centerY;
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        
        [_scrollView insertSubview:self.loadingImageView atIndex:0];
    }
}


- (void)setImages:(NSArray<UIImage *> *)images
{
    _images = images;
    self.loadingImageView.animationImages = images;
}

/**
 * 根据状态做相应处理 由子类实现
 */
- (void)setState:(XBRefreshState)state
{
    _state = state;
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    // 当前的contentOffset
    CGFloat currentOffsetX = self.scrollView.xb_contentOffsetX;
    
    if (currentOffsetX > 0) return;
    
    if (self.scrollView.isDragging && currentOffsetX < 0) {
        self.state = XBRefreshStatePulling;
    } else if (!self.scrollView.isDragging && currentOffsetX < 0) {
        self.state = XBRefreshStateRefreshing;
    }
    
}
/**
 * 开始执行动画 由子类实现
 */
- (void)beginRefreshing
{
    
}

/**
 * 结束动画
 */
- (void)endRefreshing
{
    self.state = XBRefreshStateNormal;
}

/**
 * 调用回调 子类实现
 */
- (void)callBackHandler
{
    
}


@end
