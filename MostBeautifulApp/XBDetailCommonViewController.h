//
//  XBCommonViewController.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBMenuView.h"
#import "XBHomeRightButton.h"
@class App;
@class XBContentView;
@class XBHomeToolBar;
@class XBScrollView;
@class AppFavorite;
@class XBShareWeChatView;
@class XBShareView;
@class TTTAttributedLabel;
@interface XBDetailCommonViewController : UIViewController

/** 返回按钮 */
@property (strong, nonatomic) UIButton          *backButton;
/** header */
@property (strong, nonatomic) UIView            *headerView;
/** 标题view */
@property (strong, nonatomic) UIView            *titleView;
/** 标题 */
@property (strong, nonatomic) UILabel           *titleLabel;
/** 子标题 */
@property (strong, nonatomic) UILabel           *subTitleLabel;
/** 分享、收藏、下载 */
@property (strong, nonatomic) XBMenuView        *menuView;
/** 导航栏上的菜单 */
@property (strong, nonatomic) XBMenuView        *naviBarMenuView;
/** 封面图片 */
@property (strong, nonatomic) UIImageView       *coverImageView;
/** 应用图片 */
@property (strong, nonatomic) UIImageView       *avatorImageView;
/** 滚动view */
@property (strong, nonatomic) UIScrollView      *scrollView;
/** 工具栏 */
@property (strong, nonatomic) XBHomeToolBar     *toolBar;
/** 图文内容view  */
@property (strong, nonatomic) XBContentView     *contentView;
/** 分享到微信 */
@property (strong, nonatomic) XBShareWeChatView *shareWeChatView;
/** 分享view */
@property (strong, nonatomic) XBShareView       *shareView;

/** 当前要显示的app信息 */
@property (strong, nonatomic) App           *app;
/** 收藏的app */
@property (strong, nonatomic) AppFavorite   *appFavorite;

/** 导航栏右边按钮 */
@property (assign, nonatomic) XBHomeRightType  homeRightType;

/** 封面缓存图 */
@property (strong, nonatomic) UIImageView  *tempImageView;

- (void)shareWeChatViewDidSelected;

- (void)contentAttributedLabel:(TTTAttributedLabel *)label
          didSelectLinkWithURL:(NSURL *)url;

- (void)menuView:(XBMenuView *)menuView
        didSelectedWithType:(XBMenuViewDidSelectedType)type
        atIndex:(NSInteger)index;

- (void)toolBarDidSelectedBeautiful:(XBHomeToolBar *)toolBar;

- (void)toolBarDidSelectedFeel:(XBHomeToolBar *)toolBar;

- (void)toolBarDidSelectedComment:(XBHomeToolBar *)toolBar;

@end
