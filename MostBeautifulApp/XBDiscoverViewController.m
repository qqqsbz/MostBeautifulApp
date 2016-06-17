//
//  XBDiscoverViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDiscoverViewController.h"
#import "AppDelegate.h"
#import "XBHomeViewController.h"
#import "XBDiscoverCell.h"
#import "UIImage+Util.h"
#import "XBRefreshAutoFooter.h"
#import "XBDiscoverDetailViewController.h"
#import "XBDiscoverPublishViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface XBDiscoverViewController () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UISegmentedControl  *segmentedControl;
@property (strong, nonatomic) UIScrollView        *contentScrollView;
@property (strong, nonatomic) UITableView         *hotTableView;
@property (strong, nonatomic) UITableView         *novelTableView;
@property (assign, nonatomic) NSInteger           hotPage;
@property (assign, nonatomic) NSInteger           hotPageSize;
@property (assign, nonatomic) NSInteger           novelPageSize;
@property (assign, nonatomic) NSInteger           currentPage;
@property (strong, nonatomic) NSArray             *loadingImages;
@property (strong, nonatomic) NSArray             *hotDatas;
@property (strong, nonatomic) NSArray             *novelDatas;
@property (strong, nonatomic) XBRefreshAutoFooter *hotFooter;
@property (strong, nonatomic) XBRefreshAutoFooter *novelFooter;
@end

static NSString *hotReuseIdentifier = @"XBDiscoverCell";
static NSString *novelReuseIdentifier = @"XBDiscoverCell";
@implementation XBDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hotPage = 1;
    self.hotPageSize = 10;
    self.novelPageSize = 10;
    
    self.loadingImages = @[
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_1"] toScale:0.3],
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_2"] toScale:0.3],
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_3"] toScale:0.3],
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_4"] toScale:0.3],
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_5"] toScale:0.3],
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_6"] toScale:0.3],
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_7"] toScale:0.3],
                        [UIImage scaleImage:[UIImage imageNamed:@"loading_8"] toScale:0.3],
                        ];
    
    [self buildNavigationItem];
    
    [self buildContentScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self defaultBackground];
    
    //修复跳转到详情页后 返回不默认选中已选页面
    self.segmentedControl.selectedSegmentIndex = self.currentPage;
    
    [self.contentScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.contentScrollView.frame) * self.currentPage,self.contentScrollView.contentOffset.y) animated:NO];
}

- (void)buildNavigationItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 18);
    [leftButton setImage:[UIImage imageNamed:@"home_icon_sidebar_normal"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    [self.navigationController.navigationBar addSubview:leftButton];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 18);
    [rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"最热分享",@"最新分享"]];
    self.segmentedControl.frame = CGRectMake(0, 0, CGRectGetWidth(self.navigationController.navigationBar.frame) * 0.62, CGRectGetHeight(self.navigationController.navigationBar.frame) * 0.65);
    self.segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    self.segmentedControl.tintColor = [UIColor whiteColor];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;


}


- (void)buildContentScrollView
{
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.contentScrollView.delegate = self;
    self.contentScrollView.scrollEnabled = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator  = NO;
    [self.view addSubview:self.contentScrollView];
    
    CGFloat space = CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    self.hotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentScrollView.frame), CGRectGetHeight(self.contentScrollView.frame) - space)];
    self.hotTableView.tag = 0;
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    self.hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.hotTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBDiscoverCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:hotReuseIdentifier];
    [self.contentScrollView addSubview:self.hotTableView];
    
    self.novelTableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentScrollView.frame), 0, CGRectGetWidth(self.contentScrollView.frame), CGRectGetHeight(self.contentScrollView.frame) - space)];
    self.novelTableView.tag = 1;
    self.novelTableView.delegate = self;
    self.novelTableView.dataSource = self;
    self.novelTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.novelTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBDiscoverCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:novelReuseIdentifier];
    [self.contentScrollView addSubview:self.novelTableView];
    
    [self addFooterHeaderViewForHotTableView];
    [self addFooterHeaderViewForNovelTableView];
}

#pragma mark -- 加载最热分享
- (void)addFooterHeaderViewForHotTableView
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[XBHttpClient shareInstance] getHotDiscoverWithPage:1 pageSize:self.hotPageSize success:^(NSArray *datas) {
            self.hotDatas = datas;
            [self.hotTableView reloadData];
            [self.hotTableView.mj_header endRefreshing];
            self.hotTableView.mj_footer.hidden = NO;
        } failure:^(NSError *error) {
            [self showFail:@"加载失败!"];
            [self.hotTableView.mj_header endRefreshing];
        }];
    }];
    
    [header setImages:self.loadingImages forState:MJRefreshStateIdle];
    [header setImages:self.loadingImages forState:MJRefreshStatePulling];
    [header setImages:self.loadingImages forState:MJRefreshStateRefreshing];
    self.hotTableView.mj_header = header;
    [self.hotTableView.mj_header beginRefreshing];
    
    self.hotFooter = [XBRefreshAutoFooter footerWithRefreshingBlock:^{
        self.hotPage += 1;
        [[XBHttpClient shareInstance] getHotDiscoverWithPage:self.hotPage pageSize:self.hotPageSize success:^(NSArray *datas) {
            if (datas.count > 0) {
                self.hotDatas = [self.hotDatas arrayByAddingObjectsFromArray:datas];
                [self.hotTableView reloadData];
                [self.hotTableView.mj_footer endRefreshing];
            } else {
                
                [self.hotTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError *error) {
            [self showFail:@"加载失败!"];
            [self.hotTableView.mj_footer endRefreshing];
            self.hotPage -= 1;
        }];
    }];
    
    self.hotFooter.type = XBRefreshAutoFooterTypeDiscover;
    self.hotFooter.loadColor = [UIColor colorWithHexString:@"#414141"];
    self.hotTableView.mj_footer = self.hotFooter;
    self.hotTableView.mj_footer.hidden = YES;
}

#pragma mark -- 加载最新分享
- (void)addFooterHeaderViewForNovelTableView
{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [[XBHttpClient shareInstance] getNovelDiscoverWithPos:-1 pageSize:self.novelPageSize success:^(NSArray *datas) {
            self.novelDatas = datas;
            [self.novelTableView reloadData];
            [self.novelTableView.mj_header endRefreshing];
            self.novelTableView.mj_footer.hidden = NO;
        } failure:^(NSError *error) {
            [self showFail:@"加载失败!"];
            [self.novelTableView.mj_header endRefreshing];
        }];
    }];
    
    [header setImages:self.loadingImages forState:MJRefreshStateIdle];
    [header setImages:self.loadingImages forState:MJRefreshStatePulling];
    [header setImages:self.loadingImages forState:MJRefreshStateRefreshing];
    self.novelTableView.mj_header = header;
    
    self.novelFooter = [XBRefreshAutoFooter footerWithRefreshingBlock:^{
        Discover *lastDiscover = [self.novelDatas lastObject];
        [[XBHttpClient shareInstance] getNovelDiscoverWithPos:lastDiscover.pos pageSize:self.novelPageSize success:^(NSArray *datas) {
            if (datas.count > 0) {
                self.novelDatas = [self.novelDatas arrayByAddingObjectsFromArray:datas];
                [self.novelTableView reloadData];
                [self.novelTableView.mj_footer endRefreshing];
            } else {
                
                [self.novelTableView.mj_footer endRefreshingWithNoMoreData];
            }
        } failure:^(NSError *error) {
            [self showFail:@"加载失败!"];
            [self.novelTableView.mj_footer endRefreshing];
        }];
    }];
    self.novelFooter.type = XBRefreshAutoFooterTypeDiscover;
    self.novelFooter.loadColor = [UIColor colorWithHexString:@"#414141"];
    self.novelTableView.mj_footer = self.novelFooter;
    self.novelTableView.mj_footer.hidden = YES;
}

#pragma mark -- private method
- (void)addAction
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    XBDiscoverPublishViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([XBDiscoverPublishViewController class])];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)menuAction
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([tempAppDelegate.leftSlideVC closed]) {
        [tempAppDelegate.leftSlideVC openLeftView];
    } else {
        [tempAppDelegate.leftSlideVC closeLeftView];
    }

}

- (void)segmentedControlAction:(UISegmentedControl *)sender
{
    self.currentPage = sender.selectedSegmentIndex;
    UITableView *view = self.contentScrollView.subviews[self.currentPage];
    [self.contentScrollView setContentOffset:CGPointMake(CGRectGetWidth(view.frame) * self.currentPage, -64) animated:YES];
    
    if (view.contentOffset.y <= 0) {
        [view.mj_header beginRefreshing];
    }
    
    
}

- (void)defaultBackground
{
    UIColor *color = [UIColor colorWithHexString:@"#40A0D0"];
    self.view.backgroundColor = color;
    self.contentScrollView.backgroundColor  = color;
    self.hotTableView.backgroundColor       = color;
    self.novelTableView.backgroundColor     = color;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeBackgroundColorNotification object:color];
}

#pragma mark -- UIScorllView delegate
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
//    self.segmentedControl.selectedSegmentIndex = page;
//}

#pragma mark -- UITable data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag == 0 ? self.hotDatas.count : self.novelDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBDiscoverCell *cell ;
    Discover *discover;
    if (tableView.tag == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:hotReuseIdentifier forIndexPath:indexPath];
        discover = self.hotDatas[indexPath.row];
    } else if (tableView.tag == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:novelReuseIdentifier forIndexPath:indexPath];
        discover = self.novelDatas[indexPath.row];
    }
    cell.discover = discover;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 370.f;
}

#pragma mark -- UITable view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Discover *discover = tableView.tag == 0 ? self.hotDatas[indexPath.row] : self.novelDatas[indexPath.row];
    XBDiscoverDetailViewController *vc = [[XBDiscoverDetailViewController alloc] init];
    vc.discover = discover;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
