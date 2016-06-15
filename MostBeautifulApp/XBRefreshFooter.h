//
//  XBRefreshFooter.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/15.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRefreshView.h"

@interface XBRefreshFooter : XBRefreshView

+ (instancetype)footerWithRefreshingBlock:(XBRefreshComponentRefreshingBlock)refreshingBlock;

@end
