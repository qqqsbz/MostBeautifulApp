//
//  XBPublishCommentViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/20.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBPublishCommentViewController.h"
#import "User.h"
#import "App.h"
#import "Discover.h"
#import "UserDefaultsUtil.h"
@interface XBPublishCommentViewController () <UITextViewDelegate>
@property (strong, nonatomic) UIButton    *backButton;
@property (strong, nonatomic) UIButton    *publishButton;
@property (strong, nonatomic) UIView      *contentView;
@property (strong, nonatomic) UILabel     *placeHolder;
@property (strong, nonatomic) UITextView  *textView;
@property (strong, nonatomic) UIButton    *checkButton;
@property (strong, nonatomic) UIButton    *sinaButton;
/** 是否分享到微博 */
@property (assign, nonatomic) BOOL  synchroToSina;
@end

@implementation XBPublishCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.synchroToSina = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildNavigationBar];
    
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)buildView
{
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#E5E6E8"];
    
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:14.f];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.tintColor     = [UIColor orangeColor];
    self.textView.backgroundColor = [UIColor clearColor];
    
    self.placeHolder = [UILabel new];
    self.placeHolder.text = @"您的评论有机会展示到首页卡片上哦!";
    self.placeHolder.font = [UIFont systemFontOfSize:14.f];
    self.placeHolder.textColor = [UIColor colorWithHexString:@"#9B9EA4"];
    
    self.checkButton = [UIButton new];
    [self.checkButton setImage:[UIImage imageNamed:@"publish-checkbox-selected"] forState:UIControlStateNormal];
    [self.checkButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sinaButton = [UIButton new];
    self.sinaButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self.sinaButton setTitle:@"同时分享到微博" forState:UIControlStateNormal];
    [self.sinaButton setTitleColor:[UIColor colorWithHexString:@"#1D2935"] forState:UIControlStateNormal];
    [self.sinaButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.placeHolder];
    
    [self.view addSubview:self.checkButton];
    [self.view addSubview:self.sinaButton];
    
    [self addConstraint];
}

- (void)buildNavigationBar
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 20.f, 20.);
    [backBtn setImage:[UIImage imageNamed:@"ic_top_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.backButton = backBtn;
    
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame = CGRectMake(0, 0, 63.f, 30.);
    publishBtn.layer.masksToBounds = YES;
    publishBtn.layer.cornerRadius  = 2.f;
    [publishBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [publishBtn setBackgroundColor:[UIColor orangeColor]];
    [publishBtn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
    [publishBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    self.publishButton = publishBtn;
    
    self.title = @"写评论";
}

- (void)btnAction:(UIButton *)sender
{
    if (sender == self.backButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (sender == self.publishButton) {
        [self publishComment];
    } else if (sender == self.sinaButton || sender == self.checkButton) {
        self.synchroToSina = !self.synchroToSina;
        [self.checkButton setImage:[UIImage imageNamed:self.synchroToSina ? @"publish-checkbox-selected" : @"publish-checkbox-normal"] forState:UIControlStateNormal];
    }
}

- (void)addConstraint
{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_offset(200.f);
    }];
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    [self.placeHolder makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(13);
        make.left.equalTo(self.textView).offset(5);
    }];
    
    [self.checkButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textView);
        make.top.equalTo(self.contentView.bottom).offset(5);
    }];
    
    [self.sinaButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkButton);
        make.left.equalTo(self.checkButton.right).offset(5.f);
    }];
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolder.hidden = YES;
}


- (void)publishComment
{
    NSString *comment = self.textView.text;
    comment = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (comment.length <= 0) {
        [[SMProgressHUD shareInstancetype] showErrorTip:@"评论不能为空哦!"];
        return;
    }
    
    if (self.app) {
        [self sendAppComment];
    } else if (self.discover) {
        [self sendDiscoverComment];
    }
    
}

- (void)sendAppComment
{
    [self showLoadinngInView:self.view];
    User *user = [UserDefaultsUtil userInfo];
    NSDictionary *params = @{
                             @"comment_content":self.textView.text,
                             @"signature":@"3741b24ce615a2cf2416087a223bcdb8",
                             @"timestamp":@"1466401098",
                             @"user_id":[NSNumber numberWithInteger:user.uid]
                             };
    
    [[XBHttpClient shareInstance] postCommentWithAppId:[self.app.modelId integerValue] params:params success:^(BOOL result) {
        
        [self hideLoading];
        [[SMProgressHUD shareInstancetype] showTip:@"评论成功!"];
        [self dismissViewControllerAnimated:YES completion:nil];
        //同步到新浪微博
        
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [[SMProgressHUD shareInstancetype] showErrorTip:@"评论失败，请重试!"];
    }];

}


- (void)sendDiscoverComment
{
    [self showLoadinngInView:self.view];
    User *user = [UserDefaultsUtil userInfo];
    NSDictionary *params = @{
                             @"app_id":[NSNumber numberWithInteger:[self.discover.modelId integerValue]],
                             @"content":self.textView.text,
                             @"signature":@"3741b24ce615a2cf2416087a223bcdb8",
                             @"timestamp":@"1466401098",
                             @"user_id":[NSNumber numberWithInteger:user.uid]
                             };
    
    [[XBHttpClient shareInstance] postDiscoverCommentWithParams:params success:^(BOOL result) {
        
        [self hideLoading];
        
        [[SMProgressHUD shareInstancetype] showTip:@"评论成功!"];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //同步到新浪微博
    
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        [[SMProgressHUD shareInstancetype] showErrorTip:@"评论失败，请重试!"];
    
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
