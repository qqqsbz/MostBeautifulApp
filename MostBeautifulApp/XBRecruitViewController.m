//
//  RecruitViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/4.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kToolBarH   50.f
#import "XBRecruitViewController.h"
#import "XBRecruitNavigationBar.h"
#import "XBRecruitToolBar.h"
#import <NJKWebViewProgress/NJKWebViewProgress.h>
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
@interface XBRecruitViewController () <UIWebViewDelegate,NJKWebViewProgressDelegate,UIWebViewDelegate,XBRecruitToolBarDelegate>
@property (strong, nonatomic) UIWebView  *webView;
@property (strong, nonatomic) XBRecruitNavigationBar  *navigationBar;
@property (strong, nonatomic) XBRecruitToolBar        *toolBar;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;
@end

@implementation XBRecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildView];

}

- (void)buildView
{
    self.navigationBar = [[XBRecruitNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 68) title:@"Loading..." right:@"完成" complete:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [self.view addSubview:self.navigationBar];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.navigationBar.frame) - kToolBarH)];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    
    self.toolBar = [[XBRecruitToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.webView.frame), CGRectGetWidth(self.view.frame), kToolBarH)];
    self.toolBar.delegate = self;
    [self.view addSubview:self.toolBar];
    
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.navigationBar addSubview:_progressView];
    
    [self loadInviteUrl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)loadInviteUrl
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
    [_webView loadRequest:req];
}

#pragma mark -- UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationBar.title = title;
}

#pragma mark -- XBRecruitToolBarDelegate
- (void)didSelectedForword:(UIButton *)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)didSelectedBack:(UIButton *)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)didSelectedRefresh:(UIButton *)sender
{
    [self loadInviteUrl];
}

- (void)didSelectedShare:(UIButton *)sender
{
    NSString *string = @"最美应用招聘啦";
    NSURL *URL = [NSURL URLWithString:kApiInvite];
    
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                      applicationActivities:nil];
    [self presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         // ...
                                     }];
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

@end
