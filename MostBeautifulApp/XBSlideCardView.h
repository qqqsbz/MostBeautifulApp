//
//  SlideCardView.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBRefreshHeader;
@class XBRefreshFooter;
@protocol SlideCarViewDataSource <NSObject>

- (NSInteger)slideCardNumberOfItems;

- (UICollectionViewCell *)slideCardCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)slideCardURLStringForItemAtIndex:(NSInteger)index;

@end

@protocol SlideCarViewDataDelegate <NSObject>

- (void)slideCardCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)slideCardScrollViewDidScroll:(UIScrollView *)scrollView isScrollToItem:(BOOL)isScroll;

@end

@interface XBSlideCardView : UIView

/** 加载最新的header */
@property (strong, nonatomic) XBRefreshHeader  *xb_header;

/** 加载往后的footer */
@property (strong, nonatomic) XBRefreshFooter  *xb_footer;

/** 数据源 */
@property (weak, nonatomic) id<SlideCarViewDataSource> dataSource;

/** 代理 */
@property (weak, nonatomic) id<SlideCarViewDataDelegate> delegate;

/** 是否显示菜单 */
@property (assign, nonatomic) BOOL  showMenu;

/** 加载数据 */
- (void)slideCardReloadData;

/** 注册xib文件 */
- (void)slideCardRegisterSlideCarNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)reuseIdentifier;

/** 滚动到指定位置 */
- (void)slideCardScrollToItemAtIndex:(NSInteger)index;

/** 顶部菜单跳转到指定位置  
    防止从列表进入详情 返回列表 
    当底部菜单滚动到后面三个不自动回滚到之前的位置
*/
- (void)slideCardScrollToMenuAtIndex:(NSInteger)index;

/** 跳转到第一个位置 */
- (void)slideCardScrollToFirst;

/** 卡片滚动到指定位置 */
- (void)slideCardScrollToItemAtIndexPath:(NSIndexPath*)indexPath atScrollPosition:(UICollectionViewScrollPosition)postion animated:(BOOL)animated;

/** 根据indexPath获取cell */
- (UICollectionViewCell *)slideCardCellForIndexPath:(NSIndexPath *)indexPath;

@end


