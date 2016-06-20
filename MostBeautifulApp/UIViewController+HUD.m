//
//  UIViewController+HUD.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>
#import <MBProgressHUD/MBProgressHUD.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoadinngInView:(UIView *)view
{
    
    if ([self HUD]) {
        [[self HUD] removeFromSuperview];
    }
    
    UIImageView *loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40.f, 40.f)];
    loadImageView.animationImages = @[[UIImage imageNamed:@"loading_1"],
                                      [UIImage imageNamed:@"loading_2"],
                                      [UIImage imageNamed:@"loading_3"],
                                      [UIImage imageNamed:@"loading_4"],
                                      [UIImage imageNamed:@"loading_5"],
                                      [UIImage imageNamed:@"loading_6"],
                                      [UIImage imageNamed:@"loading_7"],
                                      [UIImage imageNamed:@"loading_8"]
                                     ];
    loadImageView.center = view.center;
    loadImageView.animationDuration = 0.8f;
    loadImageView.animationRepeatCount = NSIntegerMax;
    [loadImageView startAnimating];
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = loadImageView;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.color = [UIColor clearColor];
    [self setHUD:hud];

}

- (void)showLoadinng
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [self showLoadinngInView:view];
}

- (void)hideLoading
{
    [[self HUD] hide:YES];
    [[self HUD] removeFromSuperview];
}

- (void)showFail:(NSString *)hit
{
    [self showFail:hit afterDelay:1.f];
}

- (void)showFail:(NSString *)hit inView:(UIView *)view
{
    [self showFail:hit inView:view afterDelay:0];
}

- (void)showFail:(NSString *)hit inView:(UIView *)view afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail"]];
    hud.customView.tintColor = [UIColor clearColor];
    hud.square = YES;
    hud.labelText = hit;
    [hud hide:YES afterDelay:delay];
}

- (void)showFail:(NSString *)hit afterDelay:(NSTimeInterval)delay
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    [self showFail:hit inView:view afterDelay:delay];
}

@end
