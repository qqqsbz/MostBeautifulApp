//
//  ShareView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBShareView.h"
#import "XBShareCell.h"
#import "XBShareHeaderView.h"
#import "XBShareFooterView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "UMSocial.h"
@implementation ShareModel
+ (instancetype)shareWithImage:(UIImage *)image title:(NSString *)title plantform:(NSString *)plantform
{
    return [[self alloc] initWithImage:image title:title plantform:plantform];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title plantform:(NSString *)plantform
{
    if (self = [super init]) {
        _icon = image;
        _title = title;
        _plantform = plantform;
    }
    return self;
}

@end

@implementation ShareData

+ (instancetype)shareWithImage:(UIImage *)image content:(NSString *)content url:(NSString *)url
{
    return [[self alloc] initWithImage:image content:content url:url];
}

- (instancetype)initWithImage:(UIImage *)image content:(NSString *)content url:(NSString *)url
{
    if (self = [super init]) {
        _image = image;
        _content = content;
        _url = url;
    }
    return self;
}

@end

@interface XBShareView() <UICollectionViewDelegate,UICollectionViewDataSource,XBShareFooterViewDelegate>
@property (strong, nonatomic) UIView     *maskView;
@property (strong, nonatomic) NSArray    *datas;
@property (strong, nonatomic) ShareData  *shareData;
@property (strong, nonatomic) UICollectionView  *collectionView;
@property (strong, nonatomic) UIViewController  *targetViewController;
@end

static NSString *reuseIdentifier = @"XBShareCell";
static NSString *headerIdentifier = @"XBShareHeaderView";
static NSString *footerIdentifier = @"XBShareFooterView";
@implementation XBShareView

- (instancetype)init
{
    if (self = [super init]) {
        [self reloadData];
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self reloadData];
        [self initialization];
    }
    return self;
}

- (void)reloadData
{
    self.datas = @[
                   [ShareModel shareWithImage:[UIImage imageNamed:@"UMS_sina_icon"] title:@"新浪微博" plantform:UMShareToSina],
                   [ShareModel shareWithImage:[UIImage imageNamed:@"UMS_wechat_icon"] title:@"微信好友" plantform:UMShareToWechatSession],
                   [ShareModel shareWithImage:[UIImage imageNamed:@"UMS_wechat_timeline_icon"] title:@"微信朋友圈" plantform:UMShareToWechatTimeline],
                   [ShareModel shareWithImage:[UIImage imageNamed:@"UMS_douban_icon"] title:@"豆瓣" plantform:UMShareToDouban],
                   [ShareModel shareWithImage:[UIImage imageNamed:@"UMS_email_icon"] title:@"邮件" plantform:UMShareToEmail],
                   [ShareModel shareWithImage:[UIImage imageNamed:@"UMS_sms_icon"] title:@"短信" plantform:UMShareToSms],
                   [ShareModel shareWithImage:[UIImage imageNamed:@"UMS_alipay_icon"] title:@"支付宝" plantform:UMShareToAlipaySession]
                 ];
}

- (void)showWidthTargetViewController:(UIViewController *)targetViewController shareDataBlock:(SharePlantformData)shareDataBlock
{
    self.targetViewController = targetViewController;
    self.shareData = shareDataBlock();
    
    self.hidden = NO;
    CGRect cFrame = self.collectionView.frame;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.collectionView.frame = CGRectMake(CGRectGetMinX(cFrame), CGRectGetHeight(self.frame) - CGRectGetHeight(cFrame), CGRectGetWidth(cFrame), CGRectGetHeight(cFrame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)initialization
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45f];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame) / 4.f, CGRectGetWidth(self.frame) / 4.f);
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 0;
    
    CGFloat height = CGRectGetHeight(self.frame) * 0.6f;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), height) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBShareCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBShareHeaderView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XBShareFooterView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    [self addSubview:self.collectionView];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(self.collectionView.frame))];
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDismissHandler)]];
    [self addSubview:self.maskView];
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XBShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ShareModel *share = self.datas[indexPath.row];
    cell.iconImageView.image = share.icon;
    cell.titleLabel.text = share.title;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        XBShareHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        return headerView;
    }
    
    XBShareFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
    footerView.delegate = self;
    return footerView;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){CGRectGetWidth(collectionView.frame),60};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){CGRectGetWidth(collectionView.frame),80};
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareModel *share = self.datas[indexPath.row];
    [self shareToPlatform:share.plantform];
}

#pragma mark -- ShareFooterViewDelegate
- (void)didDismissHandler
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.collectionView.frame = CGRectMake(CGRectGetMinX(self.collectionView.frame), CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.collectionView.frame));
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark -- public method

- (void)shareToPlatform:(NSString *)platform
{
    return;
    UMSocialExtConfig *extConfig = [UMSocialData defaultData].extConfig;
    extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    extConfig.wechatTimelineData.url = self.shareData.url;
    extConfig.qzoneData.url = self.shareData.url;
    
    [[UMSocialControllerService defaultControllerService] setShareText:self.shareData.content shareImage:self.shareData.image socialUIDelegate:nil];
    [UMSocialSnsPlatformManager getSocialPlatformWithName:platform].snsClickHandler(self.targetViewController, [UMSocialControllerService defaultControllerService], YES);
}

@end
