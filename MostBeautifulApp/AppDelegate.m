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
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
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
    
    //友盟分享
    [self setUMSocial];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark -- set
- (void)setUMSocial
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:@"5751296f67e58e35910004f1"];
    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
//    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1770138639"
                                              secret:@"c928ea51c2235bf20ffceec63e8a4866"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
}

#pragma mark -- LeftSlideViewControllerDelegate
- (void)didOpenLeftView:(UIViewController *)mainVC
{
    UIViewController *viewController = [mainVC.childViewControllers lastObject];
    if ([viewController isKindOfClass:[XBHomeCommonViewController class]]) {
        XBHomeCommonViewController *homeVC = (XBHomeCommonViewController *)viewController;
        homeVC.backButton.hidden = YES;
        homeVC.showMenu = NO;
    }
}

- (void)didCloseLeftView:(UIViewController *)mainVC
{
    UIViewController *viewController = [mainVC.childViewControllers lastObject];
    if ([viewController isKindOfClass:[XBHomeCommonViewController class]]) {
        XBHomeCommonViewController *homeVC = (XBHomeCommonViewController *)viewController;
        homeVC.backButton.hidden = NO;
        homeVC.showMenu = YES;
    }
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
