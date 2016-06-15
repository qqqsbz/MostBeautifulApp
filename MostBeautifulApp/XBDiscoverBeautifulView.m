//
//  XBDiscoverBeautifulView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/13.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kSpace    10.f
#define kItemWH   34.3f
#import "XBDiscoverBeautifulView.h"
@interface XBDiscoverBeautifulView()
@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UIView            *separatorView;
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) NSMutableArray    *items;
@end
@implementation XBDiscoverBeautifulView

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
    self.titleLabel = [UILabel new];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#2D2D2D"];
//    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    self.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.titleLabel.text = @"美过的美友";
    
    self.separatorView = [UIView new];
    self.separatorView.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.separatorView];
    [self addSubview:self.scrollView];
}

- (void)reloadData
{
    NSInteger count = 0;
    if ([self.datasource respondsToSelector:@selector(numberOfItemsInBeautifulView)]) {
        count = [self.datasource numberOfItemsInBeautifulView];
    }
    
    if (count <= 0) return;
    
    self.items = [NSMutableArray arrayWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i ++) {
        
        NSString *urlString = [self.datasource discoverBeautifulView:self itemForRowAtIndex:i];
    
        UIImageView *imageView = [UIImageView new];
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [self.scrollView addSubview:imageView];
        [self.items addObject:imageView];
    }
    
    [self addConstraints];
}

- (void)addConstraints
{
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.right).offset(3);
        make.height.mas_offset(1.1f);
        make.right.equalTo(self).offset(-10);
    }];
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    
    NSInteger itemCount = self.items.count;
    
    if (itemCount < kDiscoverBeautifulRowCount) {
        
        UIImageView *firstImageView = [self.items firstObject];
        firstImageView.layer.masksToBounds = YES;
        firstImageView.layer.cornerRadius  = kItemWH / 2.f;
        
        [firstImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.scrollView);
            make.left.equalTo(self.scrollView).offset(kSpace);
            make.width.mas_offset(kItemWH);
            make.height.mas_offset(kItemWH);
        }];
        
        for (NSInteger i = 1; i < itemCount; i ++) {
            [self addConstraintTargetView:self.items[i] referView:self.items[i - 1] cornerRadius:kItemWH / 2.f];
        }
        
    } else {
        
        UIImageView *oneRowFirstImageView = [self.items firstObject];
        oneRowFirstImageView.layer.masksToBounds = YES;
        oneRowFirstImageView.layer.cornerRadius  = kItemWH / 2.f;
        [oneRowFirstImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(kSpace);
            make.top.equalTo(self.scrollView).offset(kSpace / 2.f);
            make.width.mas_offset(kItemWH);
            make.height.mas_offset(kItemWH);
        }];
        
        NSInteger size = itemCount % 2 == 0 ? itemCount / 2 : itemCount / 2 + 1;
        for (NSInteger i = 1; i < size; i ++) {
            [self addConstraintTargetView:self.items[i] referView:self.items[i - 1] cornerRadius:kItemWH / 2.f];
        }
        
        
        UIImageView *sendRowFirstImageView = self.items[size];
        sendRowFirstImageView.layer.masksToBounds = YES;
        sendRowFirstImageView.layer.cornerRadius  = kItemWH / 2.f;
        [sendRowFirstImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(kSpace);
            make.top.equalTo(oneRowFirstImageView.bottom).offset(kSpace);
            make.width.mas_offset(kItemWH);
            make.height.mas_offset(kItemWH);
        }];
        
        for (NSInteger i = size + 1; i < itemCount ; i ++) {
            [self addConstraintTargetView:self.items[i] referView:self.items[i - 1] cornerRadius:kItemWH / 2.f];
        }
        
        
        UIView *lastView = self.items[size - 1];
        [lastView layoutIfNeeded];
        [self.scrollView setContentSize:CGSizeMake(CGRectGetMaxX(lastView.frame) + kSpace, CGRectGetHeight(self.scrollView.frame))];
    }
    
}

- (void)addConstraintTargetView:(UIView *)targetView referView:(UIView *)referView cornerRadius:(CGFloat)cornerRadius
{
    targetView.layer.masksToBounds = YES;
    targetView.layer.cornerRadius  = cornerRadius;
    
    [targetView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(referView);
        make.left.equalTo(referView.right).offset(kSpace);
        make.width.equalTo(referView);
        make.height.equalTo(referView);
    }];
}

@end
