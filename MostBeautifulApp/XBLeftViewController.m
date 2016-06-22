//
//  LeftSildeViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kFooterViewHeight 50.f
#import "LeftSlideViewController.h"
#import "XBLeftViewController.h"
#import "XBLeftCell.h"
#import "User.h"
#import "XBUserDefaultsUtil.h"
#import "XBLeftFooterView.h"
#import "XBLeftHeaderView.h"
#import "XBHomeViewController.h"
#import "XBFavoriteViewController.h"
#import "XBRecruitViewController.h"
#import "XBLoginViewController.h"
#import "XBSettingViewController.h"
#import "XBSearchViewController.h"
#import "XBLiabilityViewController.h"
#import "XBArticleViewController.h"
#import "XBDiscoverViewController.h"
#import "AppDelegate.h"
@interface XBLeftViewController () <UITableViewDelegate,UITableViewDataSource,LeftFooterViewDelegate>
@property (strong, nonatomic) XBLeftHeaderView  *headerView;
@property (strong, nonatomic) XBLeftFooterView  *footerView;
@end
static NSString *reuseIdentifier = @"XBLeftCell";
@implementation XBLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTableView];
    
    [self buildFooterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackGroundColor:) name:kChangeBackgroundColorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kLoginOutSuccessNotification object:nil];
    
    //显示用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutSuccessNotification object:nil];
    
    //设置默认颜色
    UIColor *color = [UIColor colorWithHexString:@"#40A0D0"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeBackgroundColorNotification object:color];
    
    //默认选中第一个
    [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)buildTableView
{
    UITableView *tableview = [[UITableView alloc] init];
    self.tableview = tableview;
    tableview.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kFooterViewHeight);
    tableview.dataSource = self;
    tableview.delegate  = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.scrollEnabled  = NO;
    [tableview registerNib:[UINib nibWithNibName:NSStringFromClass([XBLeftCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:tableview];
    self.currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.dotImageView.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"每日最美";
        cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_apps_normal"];
    } else if (indexPath.row == 1) {
        cell.titleLabel.text = @"限免推荐";
        cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_box_normal"];
    } else if (indexPath.row == 2) {
        cell.titleLabel.text = @"发现应用";
        cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_discover_normal"];
    } else if (indexPath.row == 3) {
        cell.titleLabel.text = @"文章专栏";
        cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_article_normal"];
    } else if (indexPath.row == 4) {
        cell.titleLabel.text = @"美一下我";
        cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_beauty_normal"];
    } else if (indexPath.row == 5) {
        cell.titleLabel.text = @"我的收藏";
        cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_fav_normal"];
    }
    
    cell.dotImageView.hidden = self.currentIndexPath.row != indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBLeftCell *cell = (XBLeftCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.dotImageView.hidden = NO;

    
    if (indexPath.row == 0) {
        
        [self pushToViewController:[[XBHomeViewController alloc] init]];
        
    } else if (indexPath.row == 1) {
        
        [self pushToViewController:[[XBLiabilityViewController alloc] init]];
        
    } else if (indexPath.row == 2) {
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        tempAppDelegate.mainNavigationController.navigationBarHidden = NO;
        [self pushToViewController:[[XBDiscoverViewController alloc] init]];
        
    } else if (indexPath.row == 3) {
        
        [self pushToViewController:[[XBArticleViewController alloc] init]];
        
    } else if (indexPath.row == 4) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8"]];
        
    } else if (indexPath.row == 5) {
        
        User *user = [XBUserDefaultsUtil userInfo];
        
        [self pushToViewController:[[XBFavoriteViewController alloc] init]];
        if (!user) {
            [self presentToLogViewController];
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBLeftCell *cell = (XBLeftCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.dotImageView.hidden = YES;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (void)changeBackGroundColor:(NSNotification *)notification
{
    UIColor *color = notification.object;
    self.view.backgroundColor = color;
}

#pragma mark -- lazy load
- (XBLeftHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[XBLeftHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 110) loginBlock:^{
            [self presentToLogViewController];
        }];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (void)buildFooterView
{
    CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - kFooterViewHeight, CGRectGetWidth(self.tableview.frame) - kMainPageDistance, kFooterViewHeight);
    _footerView = [[XBLeftFooterView alloc] initWithFrame:frame leftImage:[UIImage imageNamed:@"sidebar_bottomicon_search_normal"] title:@"招聘编辑" rightImage:[UIImage imageNamed:@"sidebar_bottomicon_setting_normal"]];
    _footerView.delegate = self;
    [self.view addSubview:_footerView];
}

#pragma mark -- LeftViewDelegate
- (void)didSelectedLeftButton:(UIButton *)sender
{
    XBSearchViewController *searchVC = [[XBSearchViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)didSelectedTitleButton:(UIButton *)sender
{
    XBRecruitViewController *recruitVC = [[XBRecruitViewController alloc] init];
    [self presentViewController:recruitVC animated:YES completion:^{
        
    }];
}

- (void)didSelectedRightButton:(UIButton *)sender
{
    XBSettingViewController *settingVC = [[XBSettingViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingVC];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
}


#pragma mark -- public method
- (void)pushToViewController:(UIViewController *)vc
{
    BOOL isAlread = NO;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *childViewControllers = tempAppDelegate.mainNavigationController.childViewControllers;
    for (UIViewController *viewVC in childViewControllers) {
        if ([viewVC isKindOfClass:[vc class]]) {
            vc = viewVC;
            isAlread = YES;
        }
    }
    
    [tempAppDelegate.leftSlideVC closeLeftView];
    if (!isAlread) {
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:NO];
    } else {
        //如果控制器存在 则把控制器移到最前
        NSInteger index = [childViewControllers indexOfObject:vc];
        NSMutableArray *array = [NSMutableArray arrayWithArray:childViewControllers];
        [array exchangeObjectAtIndex:index withObjectAtIndex:array.count - 1];
        [tempAppDelegate.mainNavigationController setViewControllers:array animated:NO];
    }
}

- (void)presentToLogViewController
{
    XBLoginViewController *loginViewController = [[XBLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)loginSuccess:(NSNotification *)notification
{
    User *user = [XBUserDefaultsUtil userInfo];
    self.headerView.user = user;
    
}

@end