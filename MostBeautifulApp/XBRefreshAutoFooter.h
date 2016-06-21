//
//  XBRefreshAutoFooter.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/2.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
typedef NS_ENUM(NSInteger,XBXBRefreshAutoFooterType){
    XBRefreshAutoFooterTypeDetail = 0,
    XBRefreshAutoFooterTypeDiscover
};
@interface XBRefreshAutoFooter : MJRefreshAutoFooter

/** 非刷新状态下的文字颜色 */
@property (strong, nonatomic) UIColor  *normalColor;

/** 刷新状态下的文字颜色 */
@property (strong, nonatomic) UIColor  *loadColor;

/** 记录上次刷新的状态 */
@property (assign, nonatomic) MJRefreshState  previousState;

/** 根据类型进行展示 */
@property (assign, nonatomic) XBXBRefreshAutoFooterType  type;

@end
