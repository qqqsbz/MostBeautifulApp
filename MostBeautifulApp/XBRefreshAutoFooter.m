//
//  XBRefreshAutoFooter.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/2.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBRefreshAutoFooter.h"
@interface XBRefreshAutoFooter()
@property (strong, nonatomic) UIView   *contentView;
@property (strong, nonatomic) UILabel  *loadingLabel;
@property (strong, nonatomic) UIActivityIndicatorView  *indicatorView;
@end
@implementation XBRefreshAutoFooter

- (void)prepare
{
    [super prepare];
    
    self.normalColor = [UIColor colorWithHexString:@"#414141"];
    self.loadColor = [UIColor colorWithHexString:@"#CACACA"];
    
    self.contentView = [UIView new];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius  = 4.f;
    self.contentView.layer.borderColor   = [UIColor colorWithHexString:@"#F6F6F6"].CGColor;
    self.contentView.layer.borderWidth   = 1.f;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.loadingLabel = [UILabel new];
    self.loadingLabel.text = @"显示更多";
    self.loadingLabel.textColor = self.normalColor;
//    self.loadingLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.f];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.hidden = YES;

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.loadingLabel];
    [self.contentView addSubview:self.indicatorView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat  w = self.type == XBRefreshAutoFooterTypeDetail ? 60.f : 20.f;
    self.contentView.frame = CGRectMake(w / 2.f, 5, CGRectGetWidth(self.frame) - w, CGRectGetHeight(self.frame) - 5);
    
    self.loadingLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) / 2.f - 20.f, -2.5f, 80.f, CGRectGetHeight(self.frame));
    
    CGRect frame = self.indicatorView.frame;
    frame.origin.x = CGRectGetMinX(self.loadingLabel.frame) - 30.f;
    frame.origin.y = self.contentView.center.y - CGRectGetHeight(self.indicatorView.frame) / 2.f - 5.f;
    self.indicatorView.frame = frame;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

- (void)endRefreshingWithNoMoreData
{
    [super endRefreshingWithNoMoreData];
    self.previousState = MJRefreshStateNoMoreData;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.contentView.hidden = NO;
            self.loadingLabel.textColor = self.normalColor;
            [self.indicatorView stopAnimating];
            break;
        case MJRefreshStateRefreshing:
            self.loadingLabel.textColor = self.loadColor;
            [self.indicatorView startAnimating];
            break;
        case MJRefreshStateNoMoreData:
            self.contentView.hidden = YES;
            [self.indicatorView stopAnimating];
            break;
        default:
            break;
    }
}


- (void)setLoadColor:(UIColor *)loadColor
{
    _loadColor = loadColor;
    self.loadingLabel.textColor = loadColor;
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    self.loadingLabel.textColor = normalColor;
}

@end
