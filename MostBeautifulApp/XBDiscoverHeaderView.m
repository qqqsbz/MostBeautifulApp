//
//  XBDiscoverHeaderView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kHeight   CGRectGetHeight(self.frame)
#define kAvatorWH kHeight * 0.3f
#define kIconWH   kHeight * 0.41f
#import "XBDiscoverHeaderView.h"
@interface XBDiscoverHeaderView()
@property (strong, nonatomic) UIView  *topView;
@property (strong, nonatomic) UIView  *bottomView;
@end
@implementation XBDiscoverHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    
    self.topView = [UIView new];
    self.bottomView = [UIView new];
    
    self.avatorImageView = [UIImageView new];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#1C1C1C"];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    
    self.plantformLabel = [UILabel new];
    self.plantformLabel.textColor = [UIColor colorWithHexString:@"#D3D7D8"];
    self.plantformLabel.font = [UIFont systemFontOfSize:11.f];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#D6D9DC"];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius  = 8.f;
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#2E2E2E"];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.f];
    
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    [self.topView addSubview:self.avatorImageView];
    [self.topView addSubview:self.nameLabel];
    [self.topView addSubview:self.plantformLabel];
    [self.topView addSubview:self.separatorView];
    
    [self.bottomView addSubview:self.iconImageView];
    [self.bottomView addSubview:self.titleLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(kHeight * 0.44);
    }];
    
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.bottom);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.avatorImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.right.equalTo(self.topView).offset(-10.f);
        make.width.mas_equalTo(kAvatorWH);
        make.height.mas_equalTo(kAvatorWH);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY).offset(-6);
        make.right.equalTo(self.avatorImageView.left).offset(-5);
    }];
    
    [self.plantformLabel makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatorImageView);
        make.right.equalTo(self.nameLabel);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.bottom.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.height.mas_equalTo(1.1f);
    }];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(13);
        make.centerY.equalTo(self.bottomView).offset(5.f);
        make.width.mas_equalTo(kIconWH);
        make.height.mas_equalTo(kIconWH);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.right).offset(10.f);
        make.right.equalTo(self.bottomView).offset(-10.f);
    }];
    
    [self.avatorImageView layoutIfNeeded];
    
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius  = kAvatorWH / 2.f;
}

@end
