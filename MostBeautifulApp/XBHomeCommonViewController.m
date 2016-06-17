//
//  XBHomeCommonViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kMenuHeight 55.f
#define kContentTag 10000
#define kMenuTag    20000
#import "XBHomeCommonViewController.h"
#import "AppFavorite.h"
#import "AppDelegate.h"
#import "XBHomeCell.h"
#import "UIImage+Util.h"
#import "XBHomeDetailViewController.h"
#import "XBRefreshHeader.h"
#import "XBRefreshFooter.h"
#import "UICollectionView+XBRefresh.h"
@interface XBHomeCommonViewController ()<SlideCarViewDataDelegate,SlideCarViewDataSource,UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) NSIndexPath       *currentIndexPath;

@end

static NSString *homeReuseIdentifier = @"XBHomeCell";
@implementation XBHomeCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.page = 1;
    
    self.pageSize = 10;
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self buildMenuButton];
    
    [self buildCollectionView];
    
    if (self.homeRightType == XBHomeRightTypeDaily) {
        [self headerBeginRefreshing];
    } else {
        [self reloadData];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC setPanEnabled:NO];
}

- (void)reloadData
{
    DDLogDebug(@"child must implement reloadData method");
}

- (void)loadMore
{
    DDLogDebug(@"child must implement loadMore method");
}

- (void)headerBeginRefreshing
{
    if (self.cardView.xb_header.state != XBRefreshStateRefreshing) {
        [self.cardView.xb_header beginRefreshing];
    }
}

- (void)headerEndRefreshing
{
    [self.cardView.xb_header endRefreshing];
}

- (void)footerBeginRefreshing
{
    if (self.cardView.xb_header.state != XBRefreshStateRefreshing) {
        [self.cardView.xb_footer beginRefreshing];
    }
}

- (void)footerEndRefreshing
{
    [self.cardView.xb_footer endRefreshing];
}

#pragma mark -- build view
- (void)buildCollectionView
{
    CGFloat y = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGRect contentFrame = CGRectMake(0, y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)- y);
    self.cardView = [[XBSlideCardView alloc] initWithFrame:contentFrame];
    self.cardView.delegate = self;
    self.cardView.dataSource = self;
    [self.cardView slideCardRegisterSlideCarNib:[UINib nibWithNibName:NSStringFromClass([XBHomeCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:homeReuseIdentifier];
    [self.view addSubview:self.cardView];

    if (self.homeRightType == XBHomeRightTypeDaily) {
        [self addXBRefreshView];
    }
}

- (void)addXBRefreshView
{
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%zd", i]];
        [idleImages addObject:[UIImage scaleImage:image toScale:0.3]];
    }
    
    self.cardView.xb_header = [XBRefreshHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    
    self.cardView.xb_header.images = idleImages;
    
    self.cardView.xb_footer = [XBRefreshFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    self.cardView.xb_footer.images = idleImages;

}

- (void)buildMenuButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(8, 38, 28.f, 26.f);
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"home_icon_sidebar_normal"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.homeRightButton = [[XBHomeRightButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 120 - 12, 28, 120, 40.f) homeBlock:^(){
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.cardView slideCardScrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self resetBackgroundColorIsScrollToItem:YES];
    } type:self.homeRightType];
    [self.view addSubview:self.homeRightButton];
    
}

#pragma mark -- XBSlideCarViewDatasource
- (NSInteger)slideCardNumberOfItems
{
    return self.datas.count;
}

- (UICollectionViewCell *)slideCardCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeReuseIdentifier forIndexPath:indexPath];
    cell.app = self.datas[indexPath.row];
    return cell;
}

- (NSString *)slideCardURLStringForItemAtIndex:(NSInteger)index
{
    App *app = self.datas[index];
    return app.iconImage;
}


#pragma mark -- XBSlideCarViewDelegate
- (void)slideCardCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    XBHomeDetailViewController *vc = [[XBHomeDetailViewController alloc] init];
    vc.homeRightType = self.homeRightType;
    vc.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = vc;
    vc.app = self.datas[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)slideCardScrollViewDidScroll:(UIScrollView *)scrollView isScrollToItem:(BOOL)isScroll
{
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.currentIndexPath = [NSIndexPath indexPathForRow:page inSection:0];
    [self resetBackgroundColorIsScrollToItem:isScroll];
    
    //默认当滚动到第三个起并且不是"我的收藏"、"文章专栏"显示返回首页按钮
    if (page >= 2 && (self.homeRightType != XBHomeRightTypeFavorite && self.homeRightType != XBHomeRightTypeArticle)) {
        self.homeRightButton.showHome = YES;
    }
}

- (void)menuAction
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([tempAppDelegate.leftSlideVC closed]) {
        [tempAppDelegate.leftSlideVC openLeftView];
        self.cardView.showMenu = NO;
    } else {
        [tempAppDelegate.leftSlideVC closeLeftView];
        self.cardView.showMenu = YES;
    }
}

- (void)setShowMenu:(BOOL)showMenu
{
    _showMenu = showMenu;
    self.cardView.showMenu = _showMenu;
}

- (void)resetBackgroundColorIsScrollToItem:(BOOL)isScroll
{
    App *app = self.datas[self.currentIndexPath.row];
    UIColor *color = [UIColor colorWithHexString:app.recommandedBackgroundColor];
    self.view.backgroundColor = color;
    self.homeRightButton.currentDateString = app.publishDate;
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeBackgroundColorNotification object:color];
    
    if (isScroll) {
        [self.cardView slideCardScrollToItemAtIndex:self.currentIndexPath.row];
    }
}

- (XBHomeCell *)currentHomeCell
{
    return (XBHomeCell *)[self.cardView slideCardCellForIndexPath:self.currentIndexPath];
}

#pragma mark -- setting

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
