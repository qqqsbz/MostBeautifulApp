//
//  XBPushTransition.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/30.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPushTransition.h"
#import "XBHomeCell.h"
#import "XBMenuView.h"
#import "XBContentView.h"
#import "XBHomeToolBar.h"
#import "XBHomeViewController.h"
#import "LeftSlideViewController.h"
#import "XBHomeDetailViewController.h"
@interface XBPushTransition()
@property (assign, nonatomic) XBPushTransitionType  type;
@end
@implementation XBPushTransition

+ (instancetype)transitionWithTransitionType:(XBPushTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBPushTransitionType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return .5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case XBPushTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case XBPushTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
    }
}

- (void)pushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBHomeViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBHomeDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    XBHomeCell *cell = (XBHomeCell *)[fromVC currentHomeCell];
    
    UIImageView *coverImageView = toVC.coverImageView;
    [coverImageView layoutIfNeeded];
    CGRect coverFrame = coverImageView.frame;
    coverImageView.image  = cell.coverImageView.image;
    coverImageView.frame = [cell.coverImageView convertRect:cell.coverImageView.bounds toView:containerView];
    
//    CGRect backFrame = toVC.backButton.frame;
//    toVC.backButton.frame = CGRectMake(-30, backFrame.origin.y, CGRectGetWidth(backFrame), CGRectGetHeight(backFrame));
    
    UIButton *backButton = toVC.backButton;
    CGRect backFrame = [toVC.backButton convertRect:toVC.backButton.frame toView:containerView];
    backButton.frame = CGRectMake(-60, CGRectGetMinY(backButton.frame), CGRectGetWidth(backButton.frame), CGRectGetHeight(backButton.frame));
    
    CGRect avatorFrame = toVC.avatorImageView.frame;
    toVC.avatorImageView.frame = CGRectMake(-40, CGRectGetHeight(containerView.frame) * 2 / 3, CGRectGetWidth(avatorFrame), CGRectGetHeight(avatorFrame));
    
    CGRect titleFrame = toVC.titleView.frame;
    toVC.titleView.frame = CGRectMake(-50, toVC.avatorImageView.center.y, CGRectGetWidth(titleFrame), CGRectGetHeight(titleFrame));
    
    CGRect scrollFrame  = toVC.scrollView.frame;
    CGRect contentFrame = toVC.contentView.frame;
    CGRect toolBarFrame = toVC.toolBar.frame;
    
    toVC.scrollView.frame = CGRectMake(CGRectGetMinX(scrollFrame), CGRectGetMinY(scrollFrame), CGRectGetWidth(scrollFrame), CGRectGetHeight(scrollFrame) + CGRectGetHeight(toolBarFrame));
    
    toVC.contentView.frame = CGRectMake(CGRectGetMinX(contentFrame), CGRectGetHeight(containerView.frame), CGRectGetWidth(contentFrame), CGRectGetHeight(contentFrame));
    
    toVC.toolBar.frame = CGRectMake(0, CGRectGetHeight(containerView.frame), CGRectGetWidth(toolBarFrame), CGRectGetHeight(toolBarFrame));
    
    toVC.menuView.alpha = 0.f;
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * 1.3 delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
        toVC.scrollView.frame = scrollFrame;
        backButton.frame = backFrame;
        coverImageView.frame = coverFrame;
        toVC.avatorImageView.frame = avatorFrame;
        toVC.titleView.frame = titleFrame;
        toVC.contentView.frame = contentFrame;
        toVC.toolBar.frame = toolBarFrame;
    } completion:^(BOOL finished) {
        toVC.coverImageView.hidden = NO;
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            toVC.menuView.alpha = 1.f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }];
    
}

- (void)popAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    XBHomeDetailViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBHomeViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    toVC.view.transform = CGAffineTransformMakeScale(0.94f, 0.94f);
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:toVC.view.bounds];
    backgroundView.backgroundColor = [UIColor blackColor];
    
    UIView *maskView = [[UIView alloc] initWithFrame:toVC.view.bounds];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55f];

    toVC.view.alpha = 1.f;
    [containerView insertSubview:backgroundView atIndex:0];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView insertSubview:maskView aboveSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect frame = fromVC.view.frame;
        frame.origin.x = CGRectGetWidth(frame);
        fromVC.view.frame = frame;
        
        maskView.alpha = 0.f;
        
        toVC.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
        
    } completion:^(BOOL finished) {
       
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
        if ([transitionContext transitionWasCancelled]) { //手势取消
            [toVC.view removeFromSuperview];
        }
        
        [maskView removeFromSuperview];
        [backgroundView removeFromSuperview];
    }];
}

@end
