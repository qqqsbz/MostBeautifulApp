//
//  SlideCardView.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideCarViewDataSource <NSObject>

- (NSInteger)slideCardNumberOfItems;

- (UICollectionViewCell *)slideCardCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)slideCardURLStringForItemAtIndex:(NSInteger)index;

@end

@protocol SlideCarViewDataDelegate <NSObject>

- (void)slideCardCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)slideCardScrollViewDidEndDecelerating:(UIScrollView *)scrollView isScrollToItem:(BOOL)isScroll;

@end

@interface XBSlideCardView : UIView

@property (weak, nonatomic) id<SlideCarViewDataSource> dataSource;

@property (weak, nonatomic) id<SlideCarViewDataDelegate> delegate;

@property (assign, nonatomic) BOOL  showMenu;

- (void)slideCardReloadData;

- (void)slideCardRegisterSlideCarNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)slideCardScrollToItemAtIndex:(NSInteger)index;

- (void)slideCardScrollToItemAtIndexPath:(NSIndexPath*)indexPath atScrollPosition:(UICollectionViewScrollPosition)postion animated:(BOOL)animated;

- (UICollectionViewCell *)slideCardCellForIndexPath:(NSIndexPath *)indexPath;

@end


