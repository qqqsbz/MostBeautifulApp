//
//  XBSettingFooterView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kLoginViewH CGRectGetHeight(self.frame) * 0.5
#define kImageWH 25.f
#import "XBSettingFooterView.h"
@interface XBSettingFooterView()

@property (strong, nonatomic) UIView        *loginOutView;
@property (strong, nonatomic) UIImageView   *loginOutImageView;
@property (strong, nonatomic) UILabel       *loginOutLabel;
@property (copy  , nonatomic) dispatch_block_t  block;
@end
@implementation XBSettingFooterView

- (instancetype)initDidSelectedLoginOutBlock:(dispatch_block_t)block
{
    if (self = [super init]) {
        _block = block;
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame didSelectedLoginOutBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        _block = block;
        [self initialization];
    }
    return self;
}


- (void)initialization
{
    self.loginOutView = [UIView new];
    self.loginOutView.backgroundColor = [UIColor colorWithHexString:@"#49AAF5"];
    [self.loginOutView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)]];
    
    self.loginOutView.layer.masksToBounds = YES;
    self.loginOutView.layer.cornerRadius  = 5.f;
    
    self.loginOutImageView = [UIImageView new];
    self.loginOutImageView.image = [UIImage imageNamed:@"sina"];
    
    self.loginOutLabel = [UILabel new];
    self.loginOutLabel.text = @"退出当前账号";
    self.loginOutLabel.textColor = [UIColor whiteColor];
    self.loginOutLabel.font = [UIFont systemFontOfSize:15.f];
    
    [self addSubview:self.loginOutView];
    [self.loginOutView addSubview:self.loginOutImageView];
    [self.loginOutView addSubview:self.loginOutLabel];
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.loginOutView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.f);
        make.right.equalTo(self).offset(-15.f);
        make.height.mas_equalTo(kLoginViewH);
        make.centerY.equalTo(self);
    }];
    
    [self.loginOutLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.loginOutView);
        make.left.equalTo(self.loginOutView.centerX).offset(-30.f);
    }];
    
    [self.loginOutImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginOutLabel.left).offset(-5);
        make.centerY.equalTo(self.loginOutLabel.centerY);
        make.width.mas_equalTo(kImageWH);
        make.height.mas_equalTo(kImageWH);
    }];
}

- (void)tapGesture
{
    if (self.block) {
        self.block();
    }
}

@end
