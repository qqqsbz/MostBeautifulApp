//
//  XBSearchDetailViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchDetailViewController.h"
#import "XBMenuView.h"
#import "AppFavorite.h"
#import "XBContentView.h"
#import "XBHomeToolBar.h"
#import "XBShareWeChatView.h"
#import "SMProgressHUD.h"
#import "XBSearchPushTransition.h"

@interface XBSearchDetailViewController () <XBContentViewDelegate,XBMenuViewDelegate,XBHomeToolBarDelegate,XBShareWeChatViewDelegate>

@end

@implementation XBSearchDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuView.delegate = self;
    
    self.contentView.delegate = self;
    
    self.toolBar.toolBarDelegate = self;
    
    self.shareWeChatView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)menuAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [XBSearchPushTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBSearchPushTransitionTypePush : XBSearchPushTransitionTypePop];
}

#pragma mark -- XBMenuViewDelegate
- (void)menuView:(XBMenuView *)menuView didSelectedWithType:(XBMenuViewDidSelectedType)type atIndex:(NSInteger)index
{
    [super menuView:menuView didSelectedWithType:type atIndex:index];
}

#pragma mark -- XBContentViewDelegate
- (void)contentAttributedLabel:(TTTAttributedLabel *)label
          didSelectLinkWithURL:(NSURL *)url
{
    [super contentAttributedLabel:label didSelectLinkWithURL:url];
}

#pragma mark -- XBHomeToolBarDelegate
- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedBeautiful:(UIImageView *)imageView
{
    [super toolBar:toolbar didSelectedBeautiful:imageView];
}

- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedFeel:(UIImageView *)imageView
{
    [super toolBar:toolbar didSelectedFeel:imageView];
}

- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedComment:(UILabel *)commentLabel
{
    [super toolBar:toolbar didSelectedComment:commentLabel];
}

#pragma mark -- XBShareWeChatViewDelegate
- (void)shareWeChatViewDidSelected
{
    [super shareWeChatViewDidSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
