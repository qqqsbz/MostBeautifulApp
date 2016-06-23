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
#import "Item.h"
#import "Menu.h"
#import "Config.h"
#import "SideMenu.h"
#import "DBUtil.h"
#import "AboutConfig.h"
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
@property (strong, nonatomic) Config            *config;
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
    
    [self loadData];
}

- (void)loadData
{
    
    //查询数据库是否有今天菜单的数据
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",@"modelId",[self toDayString]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = predicate;
    
    [[DBUtil shareDBUtil] queryListWithEntityName:[Config managedObjectEntityName] fetchRequest:fetchRequest sortDescriptors:nil complete:^(NSArray *datas) {
        
        if (datas.count > 0) {
           
            NSError *error = nil;
            id model = [datas lastObject];
            Config *config = [MTLManagedObjectAdapter modelOfClass:[Config class] fromManagedObject:model error:&error];
            
            if (!error) {
            
                self.config = config;
                
                [self.tableview reloadData];
                
                self.footerView.title = self.config.aboutConfig.itemOnSideBar.title;
                
                self.footerView.titleEnable = YES;
                
                //默认选中第一个
                [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                
            }
        } else {
            
            [self loadDataFromServer];
       
        }
        
    }];
    
   
}

- (void)loadDataFromServer
{
    //没有数据则访问服务器获取数据
    [[XBHttpClient shareInstance] getConfigWithSuccess:^(Config *config) {
        
        //获取可显示的菜单
        NSMutableArray *menus = [NSMutableArray arrayWithCapacity:self.config.sideMenu.menuList.count];
        
        for (Menu *menu in self.config.sideMenu.menuList) {
            if (menu.canShow) {
                [menus addObject:menu];
            }
        }
        
        self.config.sideMenu.menuList = menus;
        
        config.modelId = [self toDayString];
        
        self.config = config;
        
        self.footerView.title = self.config.aboutConfig.itemOnSideBar.title;
        
        self.footerView.titleEnable = YES;
        
        [self.tableview reloadData];
        
        //默认选中第一个
        [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        //保存到数据库
        [[DBUtil shareDBUtil] add:self.config];
        
    } failure:^(NSError *error) {
        [self showFail:@"获取菜单失败!" inView:self.view];
    }];
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
    [self.tableview reloadData];
    
    //默认选中第一个
    [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.config.sideMenu.menuList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.dotImageView.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.config) {
        if (indexPath.row < self.config.sideMenu.menuList.count) {
            Menu *menu = self.config.sideMenu.menuList[indexPath.row];
            cell.titleLabel.text = menu.verboseName;
            if ([menu.name isEqualToString:@"niceapp"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_apps_normal"];
            } else if ([menu.name isEqualToString:@"free_app"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_box_normal"];
            } else if ([menu.name isEqualToString:@"community"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_discover_normal"];
            } else if ([menu.name isEqualToString:@"article"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_article_normal"];
            } else if ([menu.name isEqualToString:@"pingfen"]) {
                cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_beauty_normal"];
            }
        } else {
            cell.titleLabel.text = @"我的收藏";
            cell.iconImageView.image = [UIImage imageNamed:@"sidebar_icon_fav_normal"];
        }
    } else {
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

    if (self.config) {
        
        if (indexPath.row < self.config.sideMenu.menuList.count) {
            Menu *menu = self.config.sideMenu.menuList[indexPath.row];
            if ([menu.name isEqualToString:@"niceapp"]) {
                
                [self pushToViewController:[[XBHomeViewController alloc] init]];
                
            } else if ([menu.name isEqualToString:@"free_app"]) {
                
                [self pushToViewController:[[XBLiabilityViewController alloc] init]];
                
            } else if ([menu.name isEqualToString:@"community"]) {
                
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                tempAppDelegate.mainNavigationController.navigationBarHidden = NO;
                [self pushToViewController:[[XBDiscoverViewController alloc] init]];
                
            } else if ([menu.name isEqualToString:@"article"]) {
                
                [self pushToViewController:[[XBArticleViewController alloc] init]];
                
            } else if ([menu.name isEqualToString:@"pingfen"]) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8"]];
                
            }
            
        } else {
            
            User *user = [XBUserDefaultsUtil userInfo];
            
            [self pushToViewController:[[XBFavoriteViewController alloc] init]];
            if (!user) {
                [self presentToLogViewController];
            }
        }

    } else {
        
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
    _footerView.titleEnable = NO;
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
    NSString *urlString = self.config.aboutConfig.itemOnSideBar.detail;
    recruitVC.urlString = urlString.length > 0 ? urlString : kApiInvite;
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

- (NSString *)toDayString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;//这句我也不明白具体时用来做什么。。。
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@%@%@",[NSIntegerFormatter formatToNSString:comps.year],[NSIntegerFormatter formatToNSString:comps.month],[NSIntegerFormatter formatToNSString:comps.day]];
}

- (void)loginSuccess:(NSNotification *)notification
{
    User *user = [XBUserDefaultsUtil userInfo];
    self.headerView.user = user;
    
}

@end