//
//  UICollectionView+Refresh.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^XBRefreshingBlock)();
@interface UICollectionView (Refresh)

- (void)leftWithRefreshBlock:(XBRefreshingBlock)block;

@end
