//
//  UIViewController+HUD.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showLoadinngInView:(UIView *)view;

- (void)showLoadinng;

- (void)hideLoading;

- (void)showFail:(NSString *)hit;

- (void)showFail:(NSString *)hit inView:(UIView *)view;

- (void)showFail:(NSString *)hit inView:(UIView *)view afterDelay:(NSTimeInterval)delay;

- (void)showFail:(NSString *)hit afterDelay:(NSTimeInterval)delay;

@end
