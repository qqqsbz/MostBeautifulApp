//
//  XBHomeToolBar.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBHomeToolBar;
@protocol XBHomeToolBarDelegate <NSObject>

@optional
- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedBeautiful:(UIImageView *)imageView;

- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedFeel:(UIImageView *)imageView;

- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedComment:(UILabel *)commentLabel;

@end
@interface XBHomeToolBar : UIScrollView
@property (assign, nonatomic) BOOL  isScroll;
@property (weak, nonatomic) id<XBHomeToolBarDelegate> toolBarDelegate;
@end
