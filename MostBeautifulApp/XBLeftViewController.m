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
#import "XBLeftFooterView.h"
@interface XBLeftViewController () <UITableViewDelegate,UITableViewDataSource,LeftFooterViewDelegate>
@property (strong, nonatomic) UIView  *headerView;
@property (strong, nonatomic) XBLeftFooterView  *footerView;
@end
static NSString *reuseIdentifier = @"XBLeftCell";
@implementation XBLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildTableView];
    
    [self buildFooterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBackGroundColor:) name:kChangeBackgroundColor object:nil];
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
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBLeftCell *cell = (XBLeftCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.dotImageView.hidden = YES;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 110)];
        _headerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.f, 0, 46.f, 46.f)];
        avatarImageView.image = [UIImage imageNamed:@"detail_portrait_default"];
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius  = CGRectGetWidth(avatarImageView.frame) / 2.f;
        avatarImageView.center = CGPointMake(avatarImageView.center.x, _headerView.center.y + 10.f);
        [_headerView addSubview:avatarImageView];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(0, 0, 80.f, 30.);
        loginBtn.center = CGPointMake(CGRectGetMaxX(avatarImageView.frame) + 30.f, avatarImageView.center.y);
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.f]];
        [_headerView addSubview:loginBtn];
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
    
}

- (void)didSelectedTitleButton:(UIButton *)sender
{

}

- (void)didSelectedRightButton:(UIButton *)sender
{

}
@end