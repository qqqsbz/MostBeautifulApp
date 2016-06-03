//
//  UIViewController+HUD.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/27.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showLoadinng;

- (void)hideLoading;

- (void)showFail:(NSString *)hit;

- (void)showFail:(NSString *)hit afterDelay:(NSTimeInterval)delay;

@end
