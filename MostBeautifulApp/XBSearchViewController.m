//
//  XBSearchViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchViewController.h"
#import "XBSearchNavigationBar.h"
#import "XBSearchCell.h"
#import "App.h"
#import "Search.h"
#import "DBUtil.h"
#import "XBSearchDetailViewController.h"
@interface XBSearchViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray      *datas;
@property (strong, nonatomic) NSString     *keyWord;
@property (strong, nonatomic) XBSearchNavigationBar  *searchNavigationBar;
@end

static NSString *reuseIdentifier = @"XBSearchCell";
@implementation XBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchNavigationBar.isBecomeFirstResponder = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)buildView
{
    self.searchNavigationBar = [[XBSearchNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 68.f) searchBlock:^(NSString *text) {
        
        self.keyWord = text;
        self.keyWord = [self.keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (self.keyWord.length <= 0) return ;
        
        [self showLoadinngInView:self.view];
        
        NSDictionary *param = @{@"keyword":text,
                                @"platform":[NSNumber numberWithInt:1],
                                @"signature":@"7350580536044343a383a9d104bd702e",
                                @"size":[NSNumber numberWithInt:30],
                                @"timestamp":[NSNumber numberWithLong:[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]],
                                @"user_id":[NSNumber numberWithInt:0]
                               };
        
        [[XBHttpClient shareInstance] searchWithParamter:param success:^(NSArray *datas) {
            [self hideLoading];
            self.datas = datas;
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self hideLoading];
            [self showFail:@"搜索失败!"];
        }];
        
    } cancleBlock:^{
        [self dismissViewControllerAnimated:YES completion:^{
            [self.searchNavigationBar removeFromSuperview];
        }];
    }];
    self.searchNavigationBar.isBecomeFirstResponder = YES;
    self.searchNavigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchNavigationBar];
    //隐藏导航栏 以免会挡道searchNavigationBar
    self.navigationController.navigationBarHidden = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchNavigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.searchNavigationBar.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBSearchCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.tableView];
}

#pragma mark -- UITableView Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.search = self.datas[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 0)];
    label.text = [NSString stringWithFormat:@"没有搜索到 “%@” ",self.keyWord];
    label.textColor = [UIColor colorWithHexString:@"#A6AEB1"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15.f];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (self.datas.count <= 0 && self.keyWord.length > 0) ? 50 : 0.f;
}

#pragma mark -- UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showLoadinng];
    self.currentIndexPath = indexPath;
    Search *seach = self.datas[indexPath.row];
    NSInteger appId = [seach.modelId integerValue];
    
    //查询数据库是否有该app
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"modelId", seach.modelId];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = predicate;
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"updateAt" ascending:NO];
    
    [[DBUtil shareDBUtil] queryOneWithEntityName:[App managedObjectEntityName] fetchRequest:fetchRequest sortDescriptors:@[sortDesc] complete:^(id result) {
       
        //存在 则直接获取该对象
        if (result) {
            [self hideLoading];
            NSError *error;
            App *app = [MTLManagedObjectAdapter modelOfClass:[App class] fromManagedObject:result error:&error];
            if (!error) {
                [self pushToSearchDetailViewController:app];
            }
        } else {
            
            //访问服务器获取对象
            [[XBHttpClient shareInstance] getSearchHistoryWithAppId:appId success:^(App *app) {
                [self hideLoading];
                
                //将对象保存到coredata中
                BOOL result = [[DBUtil shareDBUtil] add:app];
                if (result) {
                    DDLogDebug(@"保存成功");
                }
                
                [self pushToSearchDetailViewController:app];
            } failure:^(NSError *error) {
                [self hideLoading];
                [self showFail:@"加载失败!"];
            }];
            
        }
    }];
}

- (void)pushToSearchDetailViewController:(App *)app
{
    XBSearchDetailViewController *detailVC = [[XBSearchDetailViewController alloc] init];
    detailVC.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.delegate = detailVC;
    detailVC.app = app;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
