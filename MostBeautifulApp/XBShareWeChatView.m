//
//  XBShareWeChatView.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSeparatorH  1.f
#define kQuotesWH    13.f
#define kQuotesSpace 25.f
#define kIconWH      30.f
#define kIconSpace   10.f

#import "XBShareWeChatView.h"
@interface XBShareWeChatView()
@property (strong, nonatomic) UIView            *topView;
@property (strong, nonatomic) UIView            *bottomView;
@property (strong, nonatomic) UIImageView       *quotesLeftImageView;
@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UIImageView       *quotesRightImageView;
@property (strong, nonatomic) UIView            *separatorView;
@property (strong, nonatomic) UIImageView       *iconImageView;
@property (strong, nonatomic) UILabel           *descLabel;
@end
@implementation XBShareWeChatView

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
    UIFont *textFont = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    UIColor *backgroundColor = [UIColor colorWithHexString:@"#3C97EF"];
    
    self.backgroundColor = backgroundColor;
    self.topView.backgroundColor = backgroundColor;
    self.bottomView.backgroundColor = backgroundColor;
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 10.f;
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
    self.topView = [UIView new];
    self.bottomView = [UIView new];
    
    self.quotesLeftImageView = [UIImageView new];
    self.quotesLeftImageView.image = [UIImage imageNamed:@"detail_quotes_left"];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = textFont;
    self.titleLabel.text = @"喜欢就分享给朋友吧!";
    
    self.quotesRightImageView = [UIImageView new];
    self.quotesRightImageView.image = [UIImage imageNamed:@"detail_quotes_right"];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#43ADF3"];
    
    self.iconImageView = [UIImageView new];
    self.iconImageView.image = [UIImage imageNamed:@"detail_icon_pengyouquan_normal"];
    
    self.descLabel = [UILabel new];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.font = textFont;
    self.descLabel.text = @"点击分享到微信朋友圈";
    
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    [self.topView addSubview:self.quotesLeftImageView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.quotesRightImageView];
    [self.topView addSubview:self.separatorView];
    
    [self.bottomView addSubview:self.iconImageView];
    [self.bottomView addSubview:self.descLabel];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addConstraint];
}

- (void)addConstraint
{
    [self.topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.right.equalTo(self);
    }];
    
    [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.topView.bottom);
        make.height.equalTo(self.topView);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(self.topView);
    }];
    
    [self.quotesLeftImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.left).offset(-kQuotesSpace);
        make.bottom.equalTo(self.topView.centerY);
        make.width.mas_equalTo(kQuotesWH);
        make.height.mas_equalTo(kQuotesWH);
    }];
    
    [self.quotesRightImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).offset(kQuotesSpace);
        make.centerY.equalTo(self.titleLabel.centerY);
        make.width.equalTo(self.quotesLeftImageView);
        make.height.equalTo(self.quotesLeftImageView);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView);
        make.bottom.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.height.mas_equalTo(kSeparatorH);
    }];
    
    [self.descLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView);
        make.centerX.equalTo(self.bottomView).offset(30.f);
    }];
    
    [self.iconImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.descLabel.left).offset(-kIconSpace);
        make.centerY.equalTo(self.descLabel);
        make.width.mas_equalTo(kIconWH);
        make.height.mas_equalTo(kIconWH);
    }];
}

- (void)tapAction
{
    if ([self.delegate respondsToSelector:@selector(shareWeChatViewDidSelected)]) {
        [self.delegate shareWeChatViewDidSelected];
    }
}

@end
