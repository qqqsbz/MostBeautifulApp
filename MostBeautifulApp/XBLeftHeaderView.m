//
//  XBLeftHeaderView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kAvatorWH 46.f
#import "XBLeftHeaderView.h"
#import "User.h"
@interface XBLeftHeaderView()
@property (strong, nonatomic) UIImageView   *avatorImageView;
@property (strong, nonatomic) UIButton      *loginButton;
@property (strong, nonatomic) UILabel       *nameLabel;
@property (strong, nonatomic) UILabel       *plantformLabel;
@property (copy  , nonatomic) dispatch_block_t  block;
@end
@implementation XBLeftHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame loginBlock:(dispatch_block_t)block
{
    if (self = [super initWithFrame:frame]) {
        _block = block;
        [self initialization];
    }
    return self;
}


- (void)initialization
{
    self.avatorImageView = [UIImageView new];
    self.avatorImageView.image = [UIImage imageNamed:@"detail_portrait_default"];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.f]];
    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    self.plantformLabel = [UILabel new];
    self.plantformLabel.textColor = [UIColor whiteColor];
    self.plantformLabel.font = [UIFont systemFontOfSize:13.f];
    
    [self addSubview:self.avatorImageView];
    [self addSubview:self.loginButton];
    [self addSubview:self.nameLabel];
    [self addSubview:self.plantformLabel];
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.avatorImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self).offset(10);
        make.width.mas_equalTo(kAvatorWH);
        make.height.mas_equalTo(kAvatorWH);
    }];
    
    [self.loginButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImageView.right).offset(10.f);
        make.centerY.equalTo(self.avatorImageView);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatorImageView.right).offset(8.f);
        make.bottom.equalTo(self.avatorImageView.centerY).offset(0);
    }];
    
    [self.plantformLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.avatorImageView.centerY).offset(5);
    }];
    
    [self.avatorImageView layer];
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius  = kAvatorWH / 2.f;
    
}

- (void)setUser:(User *)user
{
    _user = user;
    if (_user) {
        self.nameLabel.text = user.name;
        self.plantformLabel.text = [user.snsType isEqualToString:@"weibo"] ? @"微博美友" : @"其他美友";
        [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:user.image] placeholderImage:[UIImage imageNamed:@"detail_portrait_default"]];
    } else {
        self.avatorImageView.image = [UIImage imageNamed:@"detail_portrait_default"];
    }
    
    BOOL isHide = user == nil;
    self.nameLabel.hidden = isHide;
    self.plantformLabel.hidden = isHide;
    self.loginButton.hidden = !isHide;
}

- (void)loginAction
{
    if (self.block) {
        self.block();
    }
}

@end
