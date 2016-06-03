//
//  HomeViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kMenuHeight 55.f
#define kContentTag 10000
#define kMenuTag    20000
#import "XBHomeViewController.h"
#import "AppDelegate.h"
#import "XBHomeCell.h"
#import "XBHomeRightButton.h"
#import "XBHomeDetailViewController.h"
#import "UICollectionView+Refresh.h"
#import "XBSlideCardView.h"
@interface XBHomeViewController () <SlideCarViewDataDelegate,SlideCarViewDataSource,UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) XBHomeRightButton *homeRightButton;
@property (strong, nonatomic) XBSlideCardView   *cardView;
@property (strong, nonatomic) NSIndexPath       *currentIndexPath;
@property (strong, nonatomic) NSArray  *datas;
@property (assign, nonatomic) NSInteger  page;
@end

static NSString *homeReuseIdentifier = @"XBHomeCell";
@implementation XBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 10;
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self buildMenuButton];
    
    [self buildCollectionView];
    
    [self reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [self showLoadinng];
    self.homeRightButton.hidden = YES;
    [[XBHttpClient shareInstance] getTodayWithPageSize:self.page Success:^(NSArray *datas) {
        self.datas = datas;
        [self.cardView slideCardReloadData];
        [self resetBackgroundColorIsScrollToItem:YES];
        [self hideLoading];
        self.homeRightButton.hidden = NO;
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showFail:@"加载失败!"];
    }];
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
}

- (void)buildMenuButton
{
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 20, 18);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"home_icon_sidebar_normal"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    //    [self menuAction];
    
    self.homeRightButton = [[XBHomeRightButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30.f) homeBlock:^(){
        self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.cardView slideCardScrollToItemAtIndexPath:self.currentIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self resetBackgroundColorIsScrollToItem:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.homeRightButton];
}

#pragma mark -- UICollectionViewDatasource
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


#pragma mark -- UICollectionViewDelegate
- (void)slideCardCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentIndexPath = indexPath;
    XBHomeDetailViewController *vc = [[XBHomeDetailViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = vc;
    vc.app = self.datas[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)slideCardScrollViewDidEndDecelerating:(UIScrollView *)scrollView isScrollToItem:(BOOL)isScroll
{
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    self.currentIndexPath = [NSIndexPath indexPathForRow:page inSection:0];
    [self resetBackgroundColorIsScrollToItem:isScroll];
}

#pragma mark -- UIViewControllerTransitioningDelegate
//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//{
//    return [XBPresentTransition transitionWithTransitionType:XBPresentTransitionTypePresent];
//}
//
//- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//{
//    return [XBPresentTransition transitionWithTransitionType:XBPresentTransitionTypeDismiss];
//}

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
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeBackgroundColor object:color];
    
    if (isScroll) {
        [self.cardView slideCardScrollToItemAtIndex:self.currentIndexPath.row];
    }
}

- (XBHomeCell *)currentHomeCell
{
    return (XBHomeCell *)[self.cardView slideCardCellForIndexPath:self.currentIndexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
