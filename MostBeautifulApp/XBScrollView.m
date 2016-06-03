//
//  XBScrollView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/1.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBScrollView.h"

@implementation XBScrollView

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
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
    
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.top);
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.greaterThanOrEqualTo(self.height);
        make.width.equalTo(self.width);
    }];
}

@end
