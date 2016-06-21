//
//  XBHomeToolBar.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kToolBarH 45.f

#import <UIKit/UIKit.h>
@class XBHomeToolBar;
@protocol XBHomeToolBarDelegate <NSObject>

@optional
- (void)toolBarDidSelectedBeautiful:(XBHomeToolBar *)toolbar;

- (void)toolBarDidSelectedFeel:(XBHomeToolBar *)toolbar;

- (void)toolBarDidSelectedComment:(XBHomeToolBar *)toolbar;

@end
@interface XBHomeToolBar : UIScrollView
/** 是否已经滚动*/
@property (assign, nonatomic) BOOL  isScroll;

/** 显示美的个数 */
@property (strong, nonatomic) UILabel       *voteLabel;

/** 美一下的图标 */
@property (strong, nonatomic) UIImageView   *voteImageView;

/** 美一下的文字 */
@property (strong, nonatomic) UILabel       *voteTitleLabel;

/** 一般般图标 */
@property (strong, nonatomic) UIImageView   *greenImageView;

/** 一般般文字 */
@property (strong, nonatomic) UILabel       *greenLabel;

/** 代理方法 */
@property (weak, nonatomic) id<XBHomeToolBarDelegate> toolBarDelegate;

@end
