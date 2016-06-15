//
//  XBRefreshHeader.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "XBRefreshView.h"
#import "XBRefreshConst.h"

@interface XBRefreshHeader : XBRefreshView

+ (instancetype)headerWithRefreshingBlock:(XBRefreshComponentRefreshingBlock)refreshingBlock;

@end
