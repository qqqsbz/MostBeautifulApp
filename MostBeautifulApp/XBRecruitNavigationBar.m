//
//  XBRecruitNavigationBar.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRecruitNavigationBar.h"

@interface XBRecruitNavigationBar()
@property (strong, nonatomic) UILabel   *titleLabel;
@property (strong, nonatomic) UIButton  *completeButton;
@property (strong, nonatomic) UIView    *separatorView;
@property (copy  , nonatomic) dispatch_block_t  block;
@end
@implementation XBRecruitNavigationBar


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title right:(NSString *)right complete:(dispatch_block_t)complete
{
    if (self = [super initWithFrame:frame]) {
        _block = complete;
        [self initializationWithTitle:title right:right];
    }
    return self;
}

- (void)initializationWithTitle:(NSString *)title right:(NSString *)right
{
    self.backgroundColor = [UIColor colorWithHexString:@"#F5F5F7"];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = title;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17.f];
    
    
    self.completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.completeButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.f]];
    [self.completeButton setTitleColor:[UIColor colorWithHexString:@"#3A7FFD"] forState:UIControlStateNormal];
    [self.completeButton setTitle:right forState:UIControlStateNormal];
    [self.completeButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#DFE0DD"];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.completeButton];
    [self addSubview:self.separatorView];
    
    [self addConstraint];
}


- (void)addConstraint
{
    [self.completeButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(12.f);
        make.right.equalTo(self).offset(-8);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.completeButton);
        make.left.equalTo(self).offset(10.f);
        make.right.equalTo(self.completeButton.left).offset(0);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1.f);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = _title;
    
    [self.completeButton updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(38.f);
    }];
}

- (void)completeAction
{
    if (self.block) {
        self.block();
    }
}

@end
