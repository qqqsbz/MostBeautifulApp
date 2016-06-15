//
//  SlideCardView.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kMenuHeight 55.f                    // 菜单栏的长度
#define kMenuLeft 7.f                       // 左边距
#define kSpace 2.f                          // 按钮之间的边距
#define kShowSpace 4.f                      // 当前显示按钮距离顶部的边距
#define kItemWidth 44.f                     // 按钮的宽度
#define kLastNumber 3                       // 最后3个按钮向左缩进
#define kItemHeight kMenuHeight + 20.f      // 按钮的长度 默认比菜单栏的长度多20 以便遮住按钮底部的圆角
#define kYSpace kMenuHeight - kSpace * 3    // 不选中按钮的顶部边距
#define kMaxItemInCenter 6                  // 大于 个在滚动都最后三个的时候自动居中

#import "XBSlideCardView.h"
#import "XBSlideItem.h"
#import "UIImage+Util.h"
#import "XBRefreshHeader.h"
#import "UICollectionView+XBRefresh.h"
@interface XBSlideCardView() <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic) UIScrollView      *menuView;
@property (assign, nonatomic) NSInteger         itemCount;
@property (strong, nonatomic) NSMutableArray    *btns;
@property (strong, nonatomic) NSMutableArray    *visibleItems;
@property (assign, nonatomic) NSInteger         previousIndex;
@property (assign, nonatomic) NSInteger         currentItemTag;
@property (assign, nonatomic) BOOL              isForwardSwip;
@property (assign, nonatomic) BOOL              isFirstLoad;
@end
@implementation XBSlideCardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(frame), CGRectGetHeight(frame) - kMenuHeight);
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, flowLayout.itemSize.width, flowLayout.itemSize.height) collectionViewLayout:flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate   = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        self.menuView = [[UIScrollView alloc] initWithFrame:CGRectMake(kMenuLeft, CGRectGetMaxY(self.collectionView.frame), CGRectGetWidth(frame) - kMenuLeft, kMenuHeight)];
        self.menuView.showsHorizontalScrollIndicator = NO;
        self.menuView.showsVerticalScrollIndicator = NO;
        self.menuView.scrollEnabled = NO;
        [self.menuView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)]];
        
        self.btns = [NSMutableArray array];
        self.isFirstLoad = YES;
        
        [self addSubview:self.collectionView];
        [self addSubview:self.menuView];
        
        // 设置普通状态的动画图片
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=8; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", i]];
            [idleImages addObject:[UIImage scaleImage:image toScale:0.3]];
        }
        
        self.collectionView.xb_header = [XBRefreshHeader headerWithRefreshingBlock:^{
            if ([self.delegate respondsToSelector:@selector(slideCardDidRefreshing)]) {
                [self.delegate slideCardDidRefreshing];
            }
            self.isFirstLoad  = YES;
        }];
        
        self.collectionView.xb_header.images = idleImages;
        
        
    }
    return self;
}

- (void)slideCardReloadData
{
    if ([self.dataSource respondsToSelector:@selector(slideCardNumberOfItems)]) {
        self.itemCount = [self.dataSource slideCardNumberOfItems];
    }
    if (self.itemCount <= 0) return;
    
    [self buildMenuButton];
    
    [self.collectionView reloadData];
    
    [self slideCardScrollToItemAtIndex:0];
}

- (void)slideCardBeginRefreshing
{
    [self.collectionView.xb_header beginRefreshing];
}

- (void)slideCardEndRefreshing
{
    [self.collectionView.xb_header endRefreshing];
}

- (void)slideCardRegisterSlideCarNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)buildMenuButton
{
    [self.btns removeAllObjects];
    [self.menuView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSString *urlString;
    
    CGFloat x;
    for (NSInteger i = 0; i < self.itemCount; i ++) {
        urlString = [self.dataSource slideCardURLStringForItemAtIndex:i];
        x = i == 0 ? 0 : kItemWidth * i + kSpace * i;
        XBSlideItem *btn = [[XBSlideItem alloc] initWithFrame:CGRectMake(x, kYSpace, kItemWidth, kItemHeight)];
        btn.tag = i;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius  = 12.f;
        btn.imageView.layer.masksToBounds = YES;
        btn.imageView.layer.cornerRadius  = 12.f;
        btn.backgroundColor = [UIColor whiteColor];
        [btn.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [self.menuView addSubview:btn];
        [self.btns addObject:btn];
    }
    
    UIButton *lastBtn = self.btns[self.btns.count - 1];
    [self.menuView setContentSize:CGSizeMake(CGRectGetMaxX(lastBtn.frame), CGRectGetHeight(self.menuView.frame))];
    
}

- (void)slideCardScrollToItemAtIndex:(NSInteger)index
{
    if (index == self.previousIndex && !self.isFirstLoad) return;
    
    XBSlideItem *item = self.btns[index];
    XBSlideItem *lastItem = self.btns[self.previousIndex];
    
    [self autoScrollTopTabBySwipDirctionToPage:index];
    
    CGFloat duration = 0.65f;
    [UIView animateWithDuration:duration delay:0.2f usingSpringWithDamping:0.55 initialSpringVelocity:1.f/0.55f options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect frame = lastItem.frame;
        frame.origin.y = kYSpace;
        lastItem.frame = frame;
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:duration / 4.f usingSpringWithDamping:0.55 initialSpringVelocity:1.f/0.55f options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = item.frame;
        frame.origin.y = kShowSpace;
        item.frame = frame;
    } completion:nil];
    
    self.previousIndex = index;
    self.isFirstLoad = NO;
    
    [self visibleSlideItems];
}

- (void)autoScrollTopTabBySwipDirctionToPage:(NSInteger)page
{
    CGFloat tag;
    CGFloat btnX;
    CGFloat subtrace;
    CGFloat spare;
    UIButton *currentBtn = self.btns[page];
    
    CGFloat frameWidth = self.frame.size.width;
    self.isForwardSwip = self.previousIndex < page;
    CGFloat tabsOffsetX = self.menuView.contentOffset.x;
    CGFloat tabsFrameWidth = self.menuView.frame.size.width;
    CGFloat tabsContentWidth = self.menuView.contentSize.width;
    
    tag = tabsOffsetX + frameWidth / 2 ;
    btnX = currentBtn.center.x;
    subtrace = self.isForwardSwip ? btnX - tag : tag - btnX;
    
    if (subtrace >= 0) {
        
        spare = self.isForwardSwip ? tabsContentWidth - (tabsOffsetX + tabsFrameWidth) : tabsOffsetX;
        
        spare = spare < 0 ? 0 : spare;
        
        CGFloat moveX = spare > subtrace ? subtrace : spare;
        
        moveX = self.isForwardSwip ? tabsOffsetX + moveX : tabsOffsetX - moveX;
        
        BOOL lastThree = page + kLastNumber >= self.btns.count;
        if (lastThree && self.itemCount > kMaxItemInCenter) {
            moveX = self.menuView.contentOffset.x + (self.isForwardSwip ? kItemWidth + kSpace : - ( kItemWidth + kSpace));
        }
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.menuView setContentOffset:CGPointMake(moveX, 0)];
        } completion:nil];
    }
}

#pragma mark -- UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(slideCardCollectionView:cellForItemAtIndexPath:)]) {
        return [self.dataSource slideCardCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark -- UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(slideCardCollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate slideCardCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)slideCardScrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)postion animated:(BOOL)animated
{
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:postion animated:animated];
}

- (UICollectionViewCell *)slideCardCellForIndexPath:(NSIndexPath *)indexPath
{
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark -- UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    if (page != self.previousIndex) {
        [self slideCardScrollToItemAtIndex:page];
        if ([self.delegate respondsToSelector:@selector(slideCardScrollViewDidEndDecelerating:isScrollToItem:)]) {
            [self.delegate slideCardScrollViewDidEndDecelerating:scrollView isScrollToItem:YES];
        }
    }
}

#pragma mark -- GestureRecognizer
-(void)panHandler:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [pan locationInView:self.menuView];
        for (XBSlideItem *btn in self.visibleItems) {
            CGRect panFrame = CGRectMake(point.x, point.y, kItemWidth / 2.f, kMenuHeight / 2.f);
            if (CGRectIntersectsRect(panFrame, btn.frame)) {
                //当前所在位置
                self.currentItemTag = btn.tag;
            }
        }
        
        for (XBSlideItem *btn in self.visibleItems) {
            
            BOOL isCurrent = btn.tag == self.currentItemTag;
            
            [self slideMenuItemWith:btn space:isCurrent ? 0 : (abs(btn.tag - self.currentItemTag) + 1 ) * kShowSpace];
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        for (XBSlideItem *btn in self.visibleItems) {
            
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, .35f * NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    
                BOOL isCurrent = btn.tag == self.currentItemTag;
                [self slideMenuItemWith:btn space:isCurrent ? kShowSpace : kYSpace];
                self.previousIndex = self.currentItemTag;
                
            });
        }
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, .1f * self.visibleItems.count * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentItemTag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            if ([self.delegate respondsToSelector:@selector(slideCardScrollViewDidEndDecelerating:isScrollToItem:)]) {
                [self.delegate slideCardScrollViewDidEndDecelerating:self.collectionView isScrollToItem:NO];
            }
        });
    }
}

- (void)slideMenuItemWith:(XBSlideItem *)item space:(CGFloat)space
{
    [UIView animateWithDuration:.65f delay:0.15f usingSpringWithDamping:0.55 initialSpringVelocity:1.f/0.55 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = item.frame;
        frame.origin.y = space;
        item.frame = frame;
    } completion:nil];
}

//获取当前显示的item
- (void)visibleSlideItems
{
    [self.visibleItems removeAllObjects];
    for (UIButton *btn in self.btns) {
        if (CGRectIntersectsRect(btn.frame, self.menuView.bounds)) {
            [self.visibleItems addObject:btn];
        }
    }
}

#pragma mark -- setting
- (void)setShowMenu:(BOOL)showMenu
{
    _showMenu = showMenu;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.menuView.alpha = _showMenu ? 1 : 0;
    } completion:nil];
}


#pragma mark -- lazy load
- (NSMutableArray *)visibleItems
{
    if (!_visibleItems) {
        _visibleItems = [NSMutableArray array];
    }
    
    return _visibleItems;
}

@end
