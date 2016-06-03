//
//  AppDelegate.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBLeftViewController.h"
#import "LeftSlideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController  *mainNavigationController;
@property (strong, nonatomic) LeftSlideViewController *leftSlideVC;

@end

