//
//  XBHomeToolBar.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kYSpace 7.f
#define kYCommentSpace 6.f
#define kWidth  CGRectGetWidth(self.frame)
#define kVoteW  kWidth * 0.48
#define kGreenW kWidth * 0.34
#define kDragWH CGRectGetHeight(self.frame) * 0.45
#define kVoteTag    10000
#define kGreenTag   20000
#define kCommentTag 30000

#import "XBHomeToolBar.h"
@interface XBHomeToolBar() <UIScrollViewDelegate>
@property (strong, nonatomic) UIView        *firstView;
@property (strong, nonatomic) UIView        *secondView;
@property (strong, nonatomic) UIView        *voteView;
@property (strong, nonatomic) UIView        *voteSeparatorView;
@property (strong, nonatomic) UIView        *greenView;
@property (strong, nonatomic) UIImageView   *rightDragImageView;
@property (strong, nonatomic) UIImageView   *leftDragImageView;
@property (strong, nonatomic) UILabel       *commentLabel;
@end
@implementation XBHomeToolBar

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
    self.pagingEnabled = YES;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#E4E8E9"];
    UIFont *textFont = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
    UIFont *numFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
    
    self.firstView = [UIView new];
    self.secondView = [UIView new];

    self.firstView.backgroundColor = [UIColor clearColor];
    self.firstView.backgroundColor = [UIColor clearColor];
    
    self.voteView = [UIView new];
    self.voteView.backgroundColor = [UIColor colorWithHexString:@"#EF805D"];
    self.voteView.layer.masksToBounds = YES;
    self.voteView.layer.cornerRadius  = 16.f;
    self.voteView.tag = kVoteTag;
    [self.voteView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    
    self.voteLabel = [UILabel new];
    self.voteLabel.textColor = [UIColor whiteColor];
    self.voteLabel.font = numFont;
    self.voteLabel.text = @"19";
    self.voteLabel.textAlignment = NSTextAlignmentCenter;
    
    self.voteSeparatorView = [UIView new];
    self.voteSeparatorView.backgroundColor = [UIColor whiteColor];
    
    self.voteImageView = [UIImageView new];
    self.voteImageView.image = [UIImage imageNamed:@"detail_icon_flower_normal"];
    
    self.voteTitleLabel = [UILabel new];
    self.voteTitleLabel.textColor = [UIColor whiteColor];
    self.voteTitleLabel.font = textFont;
    self.voteTitleLabel.text = @"美一下";

    self.greenView = [UIView new];
    self.greenView.backgroundColor = [UIColor colorWithHexString:@"#4CC8A3"];
    self.greenView.layer.masksToBounds = YES;
    self.greenView.layer.cornerRadius  = 16.f;
    self.greenView.tag = kGreenTag;
    [self.greenView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];

    self.greenImageView = [UIImageView new];
    self.greenImageView.image = [UIImage imageNamed:@"detail_icon_leaf_normal"];
    
    self.greenLabel = [UILabel new];
    self.greenLabel.textColor = [UIColor whiteColor];
    self.greenLabel.font = textFont;
    self.greenLabel.text = @"一般般";
    
    self.rightDragImageView = [UIImageView new];
    self.rightDragImageView.image = [UIImage imageNamed:@"detail_icon_drag"];
    
    self.leftDragImageView = [UIImageView new];
    self.leftDragImageView.image = [UIImage imageNamed:@"detail_icon_drag"];
    
    self.commentLabel = [UILabel new];
    self.commentLabel.text = @"    写下您的意见吧";
    self.commentLabel.layer.masksToBounds = YES;
    self.commentLabel.layer.cornerRadius  = 16.f;
    self.commentLabel.backgroundColor = [UIColor whiteColor];
    self.commentLabel.textColor = [UIColor colorWithHexString:@"#B8C1C9"];
    self.commentLabel.font = [UIFont systemFontOfSize:13.f];
    self.commentLabel.tag = kCommentTag;
    self.commentLabel.userInteractionEnabled = YES;
    [self.commentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    
    
    [self addSubview:self.firstView];
    [self addSubview:self.secondView];
    
    [self.firstView addSubview:self.voteView];
    [self.firstView addSubview:self.greenView];
    [self.firstView addSubview:self.rightDragImageView];
    
    [self.voteView addSubview:self.voteLabel];
    [self.voteView addSubview:self.voteSeparatorView];
    [self.voteView addSubview:self.voteImageView];
    [self.voteView addSubview:self.voteTitleLabel];
    
    [self.greenView addSubview:self.greenImageView];
    [self.greenView addSubview:self.greenLabel];
    
    [self.secondView addSubview:self.leftDragImageView];
    [self.secondView addSubview:self.commentLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addConstraint];
}

- (void)addConstraint
{

    [self.firstView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [self.secondView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(kWidth);
        make.width.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [self.rightDragImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.firstView);
        make.right.equalTo(self.firstView.right).offset(-10.f);
        make.height.mas_equalTo(kDragWH);
        make.width.mas_equalTo(kDragWH * 0.5);
    }];
    
    [self.greenView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightDragImageView.left).offset(-8.f);
        make.top.equalTo(self.firstView).offset(kYSpace);
        make.bottom.equalTo(self.firstView).offset(-kYSpace);
        make.width.mas_equalTo(kGreenW);
    }];
    
    [self.voteView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.greenView.left).offset(-5.f);
        make.top.equalTo(self.firstView).offset(kYSpace);
        make.bottom.equalTo(self.firstView).offset(-kYSpace);
        make.width.mas_equalTo(kVoteW);
    }];
    
    [self.greenLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.greenView.centerX).offset(-5.f);
        make.centerY.equalTo(self.greenView);
    }];
    
    [self.greenView layoutIfNeeded];
    CGFloat greenHW = CGRectGetHeight(self.greenView.frame) * 0.55;
    [self.greenImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(greenHW);
        make.height.mas_equalTo(greenHW);
        make.centerY.equalTo(self);
        make.right.equalTo(self.greenView.centerX).offset(-12.f);
    }];
    
    
    [self.voteImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.voteView);
        make.centerX.equalTo(self.voteView.centerX);
        make.width.equalTo(self.greenImageView);
        make.height.equalTo(self.greenImageView);
    }];
    
    [self.voteTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.voteView);
        make.left.equalTo(self.voteImageView.right).offset(5.f);
    }];
    
    [self.voteSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.voteImageView.left).offset(-15.f);
        make.centerY.equalTo(self.voteView);
        make.width.mas_equalTo(0.5f);
        make.height.equalTo(self.voteImageView.height);
    }];
    
    [self.voteLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.voteView);
        make.right.equalTo(self.voteSeparatorView.left).offset(-15.f);
    }];
    
    [self.leftDragImageView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.secondView);
        make.left.equalTo(self.secondView).offset(10.f);
        make.height.equalTo(self.rightDragImageView);
        make.width.equalTo(self.rightDragImageView);
    }];
    
    [self.commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftDragImageView.right).offset(5.f);
        make.top.equalTo(self.secondView).offset(kYCommentSpace);
        make.bottom.equalTo(self.secondView).offset(-kYCommentSpace);
        make.right.equalTo(self.secondView).offset(-20.f);
    }];
    
    self.contentSize = CGSizeMake(kWidth * 2, CGRectGetHeight(self.frame));
}


- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    UIView *view = [tapGesture view];
    if (view.tag == kVoteTag) {
        if ([self.toolBarDelegate respondsToSelector:@selector(toolBarDidSelectedBeautiful:)]) {
            [self.toolBarDelegate toolBarDidSelectedBeautiful:self];
        }
    } else if (view.tag == kGreenTag) {
        if ([self.toolBarDelegate respondsToSelector:@selector(toolBarDidSelectedFeel:)]) {
            [self.toolBarDelegate toolBarDidSelectedFeel:self];
        }
    } else if (view.tag == kCommentTag) {
        if ([self.toolBarDelegate respondsToSelector:@selector(toolBarDidSelectedComment:)]) {
            [self.toolBarDelegate toolBarDidSelectedComment:self];
        }
    }
}

#pragma mark -- UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isScroll = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame) == 1;
}

@end
