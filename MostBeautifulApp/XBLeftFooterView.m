//
//  LeftFooterView.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace 10.f
#define kButtonWH 25.f
#define kLeftTag  10000
#define kTitleTag 20000
#define kRightTag 30000
#import "XBLeftFooterView.h"
@interface XBLeftFooterView()
@property (strong, nonatomic) UIView    *separatorView;
@property (strong, nonatomic) UIButton  *leftButton;
@property (strong, nonatomic) UIButton  *titleButton;
@property (strong, nonatomic) UIButton  *rightButton;
@end
@implementation XBLeftFooterView

- (instancetype)initWithFrame:(CGRect)frame leftImage:(UIImage *)leftImage title:(NSString *)title rightImage:(UIImage *)rightImage
{
    if (self = [super initWithFrame:frame]) {
        self.separatorView = [UIView new];
        self.separatorView.backgroundColor = [UIColor whiteColor];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.tag = kLeftTag;
        [self.leftButton setImage:leftImage forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleButton.tag = kTitleTag;
        self.titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
        [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleButton setTitle:title forState:UIControlStateNormal];
        [self.titleButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.tag = kRightTag;
        [self.rightButton setImage:rightImage forState:UIControlStateNormal];
        [self.rightButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.separatorView];
        [self addSubview:self.leftButton];
        [self addSubview:self.titleButton];
        [self addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(kSpace);
        make.height.mas_equalTo(1.f);
        make.right.equalTo(self).offset(-kSpace);
    }];
    
    [self.leftButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.separatorView).offset(kSpace / 6.f);
        make.width.mas_equalTo(kButtonWH);
        make.height.mas_equalTo(kButtonWH);
    }];
    
    [self.titleButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftButton);
        make.centerX.equalTo(self);
    }];
    
    [self.rightButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftButton);
        make.right.equalTo(self.separatorView).offset(-kSpace / 6.f);
        make.width.mas_equalTo(kButtonWH);
        make.height.mas_equalTo(kButtonWH);
    }];
}

- (void)buttonAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (tag == kLeftTag) {
        if ([self.delegate respondsToSelector:@selector(didSelectedLeftButton:)]) {
            [self.delegate didSelectedLeftButton:sender];
        }
    } else if (tag == kTitleTag) {
        if ([self.delegate respondsToSelector:@selector(didSelectedTitleButton:)]) {
            [self.delegate didSelectedTitleButton:sender];
        }
    } else if (tag == kRightTag) {
        if ([self.delegate respondsToSelector:@selector(didSelectedRightButton:)]) {
            [self.delegate didSelectedRightButton:sender];
        }
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.titleButton setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleEnable:(BOOL)titleEnable
{
    _titleEnable = titleEnable;
    
    self.titleButton.enabled = _titleEnable;
}

@end
