//
//  RecruitToolBar.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/4.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kBackTag    10000
#define kForwardTag 20000
#define kRefreshTag 30000
#define kShareTag   40000
#import "XBRecruitToolBar.h"
#import "UIImage+Util.h"
@interface XBRecruitToolBar()
@property (strong, nonatomic) UIButton  *backButton;
@property (strong, nonatomic) UIButton  *forwardButton;
@property (strong, nonatomic) UIButton  *refreshButton;
@property (strong, nonatomic) UIButton  *shareButton;
@property (strong, nonatomic) UIView    *separatorView;
@end
@implementation XBRecruitToolBar

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
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F7"];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#DFE0DD"];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.tag = kBackTag;
    [self.backButton setImage:[UIImage image:[UIImage imageNamed:@"right"] rotation:UIImageOrientationDown] forState:UIControlStateNormal];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardButton.tag = kForwardTag;
    [self.forwardButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    self.refreshButton.tag = kRefreshTag;
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.shareButton.tag = kShareTag;
    
    [self.backButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.separatorView];
    [self addSubview:self.backButton];
    [self addSubview:self.forwardButton];
    [self addSubview:self.refreshButton];
    [self addSubview:self.shareButton];
    
    [self addConstraint];
}

- (void)addConstraint
{
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.forwardButton.left).offset(-65.f);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.forwardButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerX).offset(-20);
        make.centerY.equalTo(self.centerY);
    }];
    
    
    [self.refreshButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerX).offset(25);
        make.centerY.equalTo(self);
    }];

    [self.shareButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.refreshButton.right).offset(45.f);
        make.centerY.equalTo(self);
    }];
}

- (void)tapAction:(UIButton *)sender
{
    if (sender.tag == kForwardTag) {
        if ([self.delegate respondsToSelector:@selector(didSelectedForword:)]) {
            [self.delegate didSelectedForword:sender];
        }
    } else if (sender.tag == kBackTag) {
        if ([self.delegate respondsToSelector:@selector(didSelectedBack:)]) {
            [self.delegate didSelectedBack:sender];
        }
    } else if (sender.tag == kRefreshTag) {
        if ([self.delegate respondsToSelector:@selector(didSelectedRefresh:)]) {
            [self.delegate didSelectedRefresh:sender];
        }
    } else if (sender.tag == kShareTag) {
        if ([self.delegate respondsToSelector:@selector(didSelectedShare:)]) {
            [self.delegate didSelectedShare:sender];
        }
    }
}

@end
