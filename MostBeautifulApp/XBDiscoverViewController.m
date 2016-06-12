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
@interface XBDiscoverViewController ()
@property (strong, nonatomic) UISegmentedControl  *segmentedControl;
@end

@implementation XBDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defaultBackground];
    
    [self buildNavigationItem];
}

- (void)buildNavigationItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 18);
    [leftButton setImage:[UIImage imageNamed:@"home_icon_sidebar_normal"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 18);
    [rightButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}


- (void)addAction
{
    
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

- (void)defaultBackground
{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *viewControllers = tempAppDelegate.mainNavigationController.childViewControllers;
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[XBHomeViewController class]]) {
            self.view.backgroundColor = vc.view.backgroundColor;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
