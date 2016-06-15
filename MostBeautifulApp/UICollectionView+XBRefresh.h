//
//  UICollectionView+XBRefresh.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBRefreshHeader.h"
#import "XBRefreshFooter.h"
@interface UICollectionView (XBRefresh)
@property (strong, nonatomic) XBRefreshHeader  *xb_header;
@property (strong, nonatomic) XBRefreshFooter  *xb_footer;
@end
