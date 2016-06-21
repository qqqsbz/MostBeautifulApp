//
//  XBSearchPushTransition.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchPushTransition.h"
#import "XBMenuView.h"
#import "XBSearchCell.h"
#import "XBContentView.h"
#import "XBHomeToolBar.h"
#import "NSString+Util.h"
#import "XBSearchNavigationBar.h"
#import "XBSearchViewController.h"
#import "XBSearchDetailViewController.h"
#import "XBDetailCommonViewController.h"
@interface XBSearchPushTransition()
@property (assign, nonatomic) XBSearchPushTransitionType  type;
@end
@implementation XBSearchPushTransition

+ (instancetype)transitionWithTransitionType:(XBSearchPushTransitionType)type
{
    return [[self alloc] initWithTransitionType:type];
}

- (instancetype)initWithTransitionType:(XBSearchPushTransitionType)type
{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    switch (_type) {
        case XBSearchPushTransitionTypePush:
            [self pushAnimation:transitionContext];
            break;
        case XBSearchPushTransitionTypePop:
            [self popAnimation:transitionContext];
            break;
    }
}

- (void)pushAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{
    XBSearchViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBSearchDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    XBSearchCell *cell = [fromVC.tableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    [toVC.coverImageView layoutIfNeeded];
    CGRect coverFrame  = toVC.coverImageView.frame;
    toVC.coverImageView.frame = [cell convertRect:cell.bounds toView:containerView];
    
    UIButton *backButton = toVC.backButton;
    CGRect backFrame = [toVC.backButton convertRect:toVC.backButton.frame toView:containerView];
    backButton.frame = CGRectMake(-60, CGRectGetMinY(backButton.frame), CGRectGetWidth(backButton.frame), CGRectGetHeight(backButton.frame));
    
    CGRect avatorFrame = toVC.avatorImageView.frame;
    toVC.avatorImageView.frame = [cell convertRect:toVC.avatorImageView.bounds toView:containerView];
    
    CGRect titleFrame = toVC.titleView.frame;
    toVC.titleView.frame = toVC.avatorImageView.frame;
    
    [toVC.toolBar layoutIfNeeded];
    [toVC.contentView layoutIfNeeded];
    CGRect scrollFrame  = toVC.scrollView.frame;
    CGRect contentFrame = toVC.contentView.frame;
    CGRect toolBarFrame = toVC.toolBar.frame;
    
    toVC.scrollView.frame = CGRectMake(CGRectGetMinX(scrollFrame), CGRectGetMinY(scrollFrame), CGRectGetWidth(scrollFrame), CGRectGetHeight(scrollFrame) + CGRectGetHeight(toolBarFrame));
    
    toVC.contentView.frame = CGRectMake(CGRectGetMinX(contentFrame), CGRectGetHeight(containerView.frame), CGRectGetWidth(contentFrame), CGRectGetHeight(contentFrame));
    
    toVC.toolBar.frame = CGRectMake(0, CGRectGetHeight(containerView.frame), CGRectGetWidth(toolBarFrame), CGRectGetHeight(toolBarFrame));
    
    toVC.menuView.alpha = 0.f;
    [containerView addSubview:toVC.view];
//    [containerView addSubview:backButton];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(0.7f);
    scaleAnimation.toValue   = @(1.f);
    scaleAnimation.fillMode  = kCAFillModeForwards;
    scaleAnimation.duration  = [self transitionDuration:transitionContext];
    scaleAnimation.removedOnCompletion = NO;
    [toVC.avatorImageView.layer addAnimation:scaleAnimation forKey:@"scale"];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
        backButton.frame = backFrame;
        toVC.avatorImageView.frame = avatorFrame;
        toVC.titleView.frame = titleFrame;
        toVC.coverImageView.frame = coverFrame;
        toVC.scrollView.frame = scrollFrame;
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
    
    //对前三个cell的标题进行动画
    if (fromVC.currentIndexPath.row < 3) {
        
        XBSearchDetailViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [toVC.titleLabel layoutIfNeeded];
        [toVC.subTitleLabel layoutIfNeeded];
        
        [self viewAnimation:transitionContext tagetLabel:toVC.titleLabel toView:toVC.titleView];
        [self viewAnimation:transitionContext tagetLabel:toVC.subTitleLabel toView:toVC.titleView];
    }
}

- (void)viewAnimation:(id <UIViewControllerContextTransitioning>)transitionContext tagetLabel:(UILabel *)tagetLabel toView:(UIView *)toView
{
    UIColor *textColor = tagetLabel.textColor;
    CGSize titleSize = [tagetLabel.text sizeWithFont:tagetLabel.font maxSize:tagetLabel.frame.size];
    
    CGRect titleLabelFrame = tagetLabel.frame;
    CGRect tempFrame = [tagetLabel convertRect:CGRectMake(0, 0, titleSize.width, titleSize.height) toView:toView];
    tempFrame.size.width *= .67;
    tempFrame.size.height = titleLabelFrame.size.height;
    tagetLabel.frame = tempFrame;
    
    tagetLabel.textColor = [UIColor grayColor];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.05 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tagetLabel.frame = titleLabelFrame;
        tagetLabel.textColor = textColor;
    } completion:^(BOOL finished) {
    }];

}

- (void)popAnimation:(id <UIViewControllerContextTransitioning>)transitionContext
{

    XBSearchDetailViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    XBSearchViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    
    toVC.view.alpha = 1.f;
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] * 0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect frame = fromVC.view.frame;
        fromVC.view.xb_x = CGRectGetWidth(frame);
        
        fromVC.backButton.xb_x = CGRectGetWidth(frame);
        
        CGRect naviBarFrame = fromVC.naviBarMenuView.frame;
        fromVC.naviBarMenuView.xb_x = CGRectGetWidth(frame) + CGRectGetMinX(naviBarFrame);
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

@end
