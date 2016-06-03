//
//  SlideItem.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSlideItem.h"
@interface XBSlideItem()
@end
@implementation XBSlideItem

+ (instancetype)new
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.imageView = [UIImageView new];
    [self addSubview:self.imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.top.equalTo(self).offset(2);
        make.height.equalTo(self.width).offset(-3);
    }];
}

@end
