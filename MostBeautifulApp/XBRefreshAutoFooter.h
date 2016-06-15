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
@property (strong, nonatomic) UIColor  *normalColor;
@property (strong, nonatomic) UIColor  *loadColor;
@property (assign, nonatomic) MJRefreshState  previousState;
@property (assign, nonatomic) XBXBRefreshAutoFooterType  type;
@end
