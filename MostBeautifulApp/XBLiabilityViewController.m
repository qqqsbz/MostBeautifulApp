//
//  XBLiabilityViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBLiabilityViewController.h"
#import "App.h"
#import "AppDelegate.h"
#import "XBHomeRightButton.h"
#import "XBSlideCardView.h"
#import "XBHomeViewController.h"
@interface XBLiabilityViewController ()

@end

@implementation XBLiabilityViewController

- (void)viewDidLoad {
    
    self.homeRightType = XBHomeRightTypeLiability;
    
    [super viewDidLoad];
    
    [self closeLeftView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.datas.count > 0) {
        [super resetBackgroundColorIsScrollToItem:YES];
    }
}

- (void)reloadData
{
    [self showLoadinngInView:self.view];
    self.homeRightButton.hidden = YES;
    [[XBHttpClient shareInstance] getLiabilityWithPage:self.page pageSize:self.pageSize success:^(NSArray *datas) {
        
        self.datas = datas;
        [self.cardView slideCardReloadData];
        [super resetBackgroundColorIsScrollToItem:YES];
        [self hideLoading];
        self.homeRightButton.hidden = NO;
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showFail:@"加载失败!"];
    }];
    
}


- (void)menuAction
{
    [super menuAction];
}

- (void)closeLeftView
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.leftSlideVC closeLeftView];
    
    NSArray *viewControllers = tempAppDelegate.mainNavigationController.childViewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[XBHomeViewController class]]) {
            self.view.backgroundColor = vc.view.backgroundColor;
        }
    }
}


@end
