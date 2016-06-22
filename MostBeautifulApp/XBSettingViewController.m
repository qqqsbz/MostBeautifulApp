//
//  XBSettingViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#import "XBSettingViewController.h"
#import "XBSettingCell.h"
#import "XBShareView.h"
#import "User.h"
#import "XBUserDefaultsUtil.h"
#import "XBSettingFooterView.h"
@interface XBSettingViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView           *tableView;
@property (strong, nonatomic) XBShareView           *shareView;
@property (strong, nonatomic) XBSettingFooterView   *footerView;
@end

static NSString *reuseIdentifier = @"XBSettingCell";
@implementation XBSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更多";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [self buildLeftButton];
    
    [self buildTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)buildTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kFooterH)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBSettingCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled  = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    [self.tableView reloadData];
    [self.view addSubview:self.tableView];
    
    if (![XBUserDefaultsUtil userInfo]) {
        self.tableView.xb_height += kFooterH;
    } else {
        self.footerView = [[XBSettingFooterView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.view.frame), kFooterH) didSelectedLoginOutBlock:^{
            [XBUserDefaultsUtil clearUserInfo];
            [[SMProgressHUD shareInstancetype] showTip:@"退出成功"];
            self.footerView.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginOutSuccessNotification object:nil];
        }];
        self.footerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.footerView];
    }
}

- (void)buildLeftButton
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBtn setImage:[UIImage imageNamed:@"ic_top_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

- (void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString *imageString = @"";
    NSString *titleString = @"";
    if (indexPath.row == 0) {
        imageString = @"more_icon_aboutus_normal";
        titleString = @"关于我们";
    } else if (indexPath.row == 1) {
        imageString = @"more_icon_share";
        titleString = @"推荐给朋友";
    } else if (indexPath.row == 2) {
        imageString = @"more_icon_score_normal";
        titleString = @"评个分吧";
    } else if (indexPath.row == 3) {
        imageString = @"more_icon_feedback_normal";
        titleString = @"意见反馈";
    } else if (indexPath.row == 4) {
        imageString = @"detail_icon_delete_normal";
        titleString = @"清空缓存";
    }
    
    cell.coverImageView.image = [UIImage imageNamed:imageString];
    cell.titleLabel.text  = titleString;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.f;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    } else if (indexPath.row == 1) {
        [self.shareView showWidthTargetViewController:self shareDataBlock:^ShareData *{
            return [ShareData shareWithImage:[UIImage imageNamed:@"AppIcon"] content:@"最美应用" url:@"http://zuimeia.com/?platform=1"];
        }];
    } else if (indexPath.row == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8"]];
    } else if (indexPath.row == 3) {
        
    } else if (indexPath.row == 4) {
        [[SDImageCache sharedImageCache] cleanDisk];
        [[SMProgressHUD shareInstancetype] showTip:@"清除缓存成功"];
    }
}


#pragma mark -- lazy loading
- (XBShareView *)shareView
{
    if (!_shareView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _shareView = [[XBShareView alloc] initWithFrame:keyWindow.bounds];
        [keyWindow addSubview:_shareView];
    }
    return _shareView;
}

@end
