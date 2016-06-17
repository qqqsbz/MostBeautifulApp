//
//  XBHomeCommonViewController.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBHomeCell;
#import "XBHomeRightButton.h"
#import "XBSlideCardView.h"
@interface XBHomeCommonViewController : UIViewController

/** 返回按钮 */
@property (strong, nonatomic) UIButton  *backButton;

/** 导航栏右边菜单 */
@property (strong, nonatomic) XBHomeRightButton *homeRightButton;

/** 导航栏右边菜单栏样式 */
@property (assign, nonatomic) XBHomeRightType  homeRightType;

/** 当前页 */
@property (assign, nonatomic) NSInteger  page;

/** 页数 */
@property (assign, nonatomic) NSInteger  pageSize;

/** 数据 */
@property (strong, nonatomic) NSArray  *datas;

/** 主view */
@property (strong, nonatomic) XBSlideCardView   *cardView;

/** 是否显示菜单栏 */
@property (assign, nonatomic) BOOL  showMenu;

/** 当前选中的cell */
- (XBHomeCell *)currentHomeCell;

/** 加载数据 */
- (void)reloadData;

/** 加载更多数据 */
- (void)loadMore;

/** header正在刷新 */
- (void)headerBeginRefreshing;

/** header结束刷新 */
- (void)headerEndRefreshing;

/** footer正在刷新 */
- (void)footerBeginRefreshing;

/** footer结束刷新 */
- (void)footerEndRefreshing;

/** 设置背景颜色以及跳转到选中页 */
- (void)resetBackgroundColorIsScrollToItem:(BOOL)isScroll;

/** 打开关闭左菜单栏 */
- (void)menuAction;

@end
