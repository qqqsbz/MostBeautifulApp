//
//  UICollectionView+XBRefresh.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "UICollectionView+XBRefresh.h"
#import <objc/runtime.h>
@implementation UICollectionView (XBRefresh)

- (XBRefreshHeader *)xb_header
{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setXb_header:(XBRefreshHeader *)xb_header
{
    // 删除旧的，添加新的
    if (xb_header != self.xb_header) {
        [self.xb_header removeFromSuperview];
        [self insertSubview:xb_header atIndex:0];
        objc_setAssociatedObject(self, @selector(xb_header),
                                 xb_header, OBJC_ASSOCIATION_ASSIGN);
    }
}


- (XBRefreshFooter *)xb_footer
{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setXb_footer:(XBRefreshFooter *)xb_footer
{
    // 删除旧的，添加新的
    if (xb_footer != self.xb_footer) {
        [self.xb_footer removeFromSuperview];
        [self insertSubview:xb_footer atIndex:0];
        objc_setAssociatedObject(self, @selector(xb_footer),
                                 xb_footer, OBJC_ASSOCIATION_ASSIGN);
    }
}



@end
