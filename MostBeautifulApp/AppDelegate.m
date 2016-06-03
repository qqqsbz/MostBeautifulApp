//
//  AppDelegate.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "AppDelegate.h"
#import <DDTTYLogger.h>
#import <AFNetworkActivityIndicatorManager.h>
#import "XBHomeViewController.h"
@interface AppDelegate () <LeftSlideViewControllerDelegate>
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];   //设置通用背景颜色
    [self.window makeKeyAndVisible];
    
    XBHomeViewController *mainVC = [[XBHomeViewController alloc] init];
    self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    XBLeftViewController *leftVC = [[XBLeftViewController alloc] init];
    self.leftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
    self.leftSlideVC.delegate = self;
    self.window.rootViewController = self.leftSlideVC;
    [self setNavigationBarTranslucent];

    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        DDLogDebug(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [reachability startMonitoring];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -- LeftSlideViewControllerDelegate
- (void)didOpenLeftView:(UIViewController *)mainVC
{
    XBHomeViewController *homeVC = (XBHomeViewController *)[mainVC.childViewControllers lastObject];
    UIButton *leftBtn = homeVC.navigationItem.leftBarButtonItem.customView;
    leftBtn.hidden = YES;
    homeVC.showMenu = NO;
}

- (void)didCloseLeftView:(UIViewController *)mainVC
{
    XBHomeViewController *homeVC = (XBHomeViewController *)[mainVC.childViewControllers lastObject];
    UIButton *leftBtn = homeVC.navigationItem.leftBarButtonItem.customView;
    leftBtn.hidden = NO;
    homeVC.showMenu = YES;
}

- (void)setNavigationBarTranslucent
{
    [[UINavigationBar appearance] setTranslucent:YES];
    UIColor *color = [UIColor clearColor];
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 64.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setClipsToBounds:YES];
}


@end
