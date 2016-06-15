//
//  XBDiscoverPublishSearchViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/14.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDiscoverPublishSearchViewController.h"
#import "XBSearchNavigationBar.h"
@interface XBDiscoverPublishSearchViewController ()
@property (strong, nonatomic) XBSearchNavigationBar  *searchNavigationBar;
@property (strong, nonatomic) UITableView  *tableView;
@end

@implementation XBDiscoverPublishSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#E4E8E9"];
    
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)buildView
{
    self.searchNavigationBar = [[XBSearchNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 68.f) searchBlock:^(NSString *text) {
        [self.searchNavigationBar startAnimation];
    } cancleBlock:^{
        [self.searchNavigationBar stopAnimation];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.searchNavigationBar removeFromSuperview];
        }];
    }];
    self.searchNavigationBar.backgroundColor = [UIColor whiteColor];
    self.searchNavigationBar.placeHolderString = @"请输入名称";
    [self.view addSubview:self.searchNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
