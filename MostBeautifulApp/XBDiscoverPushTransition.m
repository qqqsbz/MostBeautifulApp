//
//  XBDiscoverPushTransition.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDiscoverPushTransition.h"
#import "XBDiscoverViewController.h"
#import "XBDiscoverDetailViewController.h"
@interface XBDiscoverPushTransition()
@property (assign, nonatomic) XBDiscoverPushTransitionType  type;
@end
@implementation XBDiscoverPushTransition
+ (instancetype)transitionWithTransitionType:(XBDiscoverPushTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBDiscoverPushTransitionType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return .35f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case XBDiscoverPushTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case XBDiscoverPushTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
    }
}

- (void)pushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBDiscoverViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBDiscoverDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    toVC.view.frame = CGRectMake(containerView.xb_width, 0, containerView.xb_width, containerView.xb_height);
    
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        toVC.view.xb_x = 0;
        fromVC.view.xb_x -= 50.f;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        fromVC.view.xb_x += 50;
    }];
}

- (void)popAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBDiscoverDetailViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBDiscoverViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
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
