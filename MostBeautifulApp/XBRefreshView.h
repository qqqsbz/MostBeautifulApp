//
//  XBRefreshView.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kXBRefreshSpace       20.f
#define kXBRefreshLoadingWH   30.f
#define kXBRefreshHeaderWidth 45.f

#import <UIKit/UIKit.h>
#import "XBRefreshConst.h"
#import "UIView+XBFrame.h"
#import "UIScrollView+XBExtension.h"

typedef enum {
    XBRefreshStatePulling = 1, // 松开就可以进行刷新的状态
    XBRefreshStateNormal = 2, // 普通状态
    XBRefreshStateRefreshing = 3, // 正在刷新中的状态
    XBRefreshStateWillRefreshing = 4, // 即将刷新状态
} XBRefreshState;

/** 进入刷新状态的回调 */
typedef void (^XBRefreshComponentRefreshingBlock)();

@interface XBRefreshView : UIView

/** 状态 */
@property (assign, nonatomic) XBRefreshState  state;

/** 加载的图片 */
@property (strong, nonatomic) NSArray<UIImage *>  *images;

/** 父view */
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

/** 正在拉伸显示 */
@property (strong, nonatomic) UIImageView  *pullingImageView;

/** 刷新中显示 */
@property (strong, nonatomic) UIImageView  *loadingImageView;

/** 回调block */
@property (copy, nonatomic) XBRefreshComponentRefreshingBlock  refreshingBlock;

/** 创建header */
+ (instancetype)refreshWithRefreshingBlock:(XBRefreshComponentRefreshingBlock)refreshingBlock;


/** 开始 */
- (void)beginRefreshing;

/** 结束 */
- (void)endRefreshing;

@end
