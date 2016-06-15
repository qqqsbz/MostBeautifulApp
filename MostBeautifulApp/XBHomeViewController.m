//
//  HomeViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//
#import "XBHomeViewController.h"
#import "DBUtil.h"
#import "App.h"
#import "AppDelegate.h"
#import "XBHomeRightButton.h"
#import "XBSlideCardView.h"
@interface XBHomeViewController ()
//<SlideCarViewDataDelegate,SlideCarViewDataSource,UIViewControllerTransitioningDelegate>
@end
@implementation XBHomeViewController

- (void)viewDidLoad {
    
    self.homeRightType = XBHomeRightTypeDaily;
    
    [super viewDidLoad];
 
    [self menuAction];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.datas.count > 0) {
        [super resetBackgroundColorIsScrollToItem:NO];
    }
}

- (void)reloadData
{
    //查看数据库是否有数据
    //查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %d",@"type",XBAppTypeApp];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 10;
    fetchRequest.predicate = predicate;
    
    //按时间升序排列
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"publishDate" ascending:NO];

    [[DBUtil shareDBUtil] queryListWithEntityName:[App managedObjectEntityName] fetchRequest:fetchRequest sortDescriptors:@[sortDesc] complete:^(NSArray *datas) {
        
        if (datas && datas.count > 0) {
            NSMutableArray *temps = [NSMutableArray arrayWithCapacity:datas.count];
            NSError *error;
            for (id managedObject in datas) {
                App *app = [MTLManagedObjectAdapter modelOfClass:[App class] fromManagedObject:managedObject error:&error];
                if (!error) {
                    [temps addObject:app];
                }
            }
            
            self.datas = temps;
            [self.cardView slideCardReloadData];
            [super resetBackgroundColorIsScrollToItem:YES];
            self.homeRightButton.hidden = NO;
            
        }
        
        //从服务器获取最新数据
        [self loadDataFromServer];
    }];
    
    
}

- (void)loadDataFromServer
{
    [super beginRefreshing];
    self.homeRightButton.hidden = YES;
    [[XBHttpClient shareInstance] getTodayWithPage:self.page PageSize:self.pageSize success:^(NSArray *datas) {
        
        self.datas = datas;
        [self.cardView slideCardReloadData];
        [super resetBackgroundColorIsScrollToItem:YES];
        self.homeRightButton.hidden = NO;
        
        //保存到数据库
        for (App *app in datas) {
            app.type = XBAppTypeApp;
            [[DBUtil shareDBUtil] add:app];
        }
        
        [super endRefreshing];
    } failure:^(NSError *error) {
        [super endRefreshing];
        [self showFail:@"加载失败!"];
    }];
}

- (void)menuAction
{
    [super menuAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
