//
//  XBCommonViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kIconWH 52.f
#define kAnimationSpace 25.f
#define  kScreenWidth  [UIScreen mainScreen].bounds.size.width

#import "XBDetailCommonViewController.h"
#import "App.h"
#import "User.h"
#import "Info.h"
#import "Comment.h"
#import "Comments.h"
#import "XBContentView.h"
#import "XBShareWeChatView.h"
#import "XBPushTransition.h"
#import "XBMenuView.h"
#import "XBHomeToolBar.h"
#import "XBScrollView.h"
#import "XBCommentCell.h"
#import "XBShareView.h"
#import "XBHomeToolBar.h"
#import "XBRefreshAutoFooter.h"
#import "XBLoginViewController.h"
#import "XBInteractiveTransition.h"
#import "XBPublishCommentViewController.h"
#import "NSString+Util.h"
#import "NSIntegerFormatter.h"
#import "AppFavorite.h"
#import "SMProgressHUD.h"
#import "XBUserDefaultsUtil.h"
#import "XBWebViewController.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <MJRefresh/MJRefresh.h>

@interface XBDetailCommonViewController ()<XBContentViewDelegate,XBMenuViewDelegate,XBHomeToolBarDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,XBShareWeChatViewDelegate,XBCommentCellDelegate>

/** 评论view */
@property (strong, nonatomic) UIView                *commnetView;
/** 评论标题 */
@property (strong, nonatomic) UILabel               *commentLabel;
/** 评论分割线 */
@property (strong, nonatomic) UIView                *commentSeparatorView;
/** 评论tableview */
@property (strong, nonatomic) UITableView           *commentTableView;
/** 评论cell */
@property (strong, nonatomic) XBCommentCell         *commentPrototype;
/** 评论加载更多 */
@property (strong, nonatomic) XBRefreshAutoFooter   *commentTableViewFooter;

/** 评论当前页数 */
@property (assign, nonatomic) NSInteger          commnetPage;
/** 评论一页显示的数据条数 */
@property (assign, nonatomic) NSInteger          commentPageSize;
/** 评论数据 */
@property (strong, nonatomic) NSArray            *datas;
/** 按钮图标 */
@property (strong, nonatomic) NSMutableArray     *menuImages;
/** 按钮标题 */
@property (strong, nonatomic) NSMutableArray     *menuTitles;
/** 封面长度 */
@property (assign, nonatomic) CGFloat            coverHeight;
/** 是否"美一下" */
@property (assign, nonatomic,getter=isBeautiful) BOOL  beautiful;
/** 是否"一般般" */
@property (assign, nonatomic,getter=isFeel)      BOOL  feel;

/** 手势处理 */
@property (strong, nonatomic) XBInteractiveTransition  *interactiveTransition;

/** 上一次的offsetY */
@property (assign, nonatomic) CGFloat  previousOffsetY;

@end

static NSString *reuseIdentifier = @"XBCommentCell";
@implementation XBDetailCommonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.commnetPage = 1;
    
    self.commentPageSize = 5;
    
    [self buildView];
    
 
    //初始化手势过渡的代理
    self.interactiveTransition = [XBInteractiveTransition interactiveTransitionWithTransitionType:XBInteractiveTransitionTypePop GestureDirection:XBInteractiveTransitionGestureDirectionRight];
    //给当前控制器的视图添加手势
    [_interactiveTransition addPanGestureForViewController:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setApp:(App *)app
{
    _app = app;
    self.titleLabel.text = app.title;
    self.subTitleLabel.text = app.subTitle;
    self.contentView.text = [[NSString stringWithFormat:@"<p>%@</p>",app.digest] stringByAppendingString:app.content];
    self.contentView.iconURLString = app.iconImage;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:app.iconImage]];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:app.coverImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.tempImageView.image = image;
    
        self.tempImageView.layer.masksToBounds = YES;
    }];
    
    [self checkIsBeautifulOrFeel];
    
    [self buildMenu];
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(self.contentView.frame));
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = CGRectGetMaxY(self.commentTableView.frame);
        [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame), height)];
    });
    
}

//创建控件
- (void)buildView
{
 
    UIColor *backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.view.backgroundColor = backgroundColor;
    
    self.tempImageView = [UIImageView new];
    self.tempImageView.hidden = YES;
    self.tempImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.tempImageView];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.toolBar = [XBHomeToolBar new];
    self.toolBar.toolBarDelegate = self;
    [self.view addSubview:self.toolBar];
    
    self.coverImageView = [UIImageView new];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:self.coverImageView];
    
    self.headerView = [UIView new];
    self.headerView.backgroundColor = backgroundColor;
    [self.scrollView addSubview:self.headerView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(5, 12, 35.f, 35.f);
    self.backButton.userInteractionEnabled = YES;
    [self.backButton setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.avatorImageView = [UIImageView new];
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius  = 12.;
    [self.headerView addSubview:self.avatorImageView];
    
    self.titleView = [UIView new];
    [self.headerView addSubview:self.titleView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21.f];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#2B2B2B"];
    [self.titleView addSubview:self.titleLabel];
    
    self.subTitleLabel = [UILabel new];
    self.subTitleLabel.numberOfLines = 1;
    self.subTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.subTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.f];
    self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#6D6D6D"];
    [self.titleView addSubview:self.subTitleLabel];
    
    self.menuView = [XBMenuView new];
    self.menuView.delegate = self;
    self.menuView.backgroundColor = backgroundColor;
    [self.scrollView addSubview:self.menuView];
    
    self.contentView = [XBContentView new];
    self.contentView.delegate = self;
    self.contentView.backgroundColor = backgroundColor;
    self.contentView.type = XBContentViewTypeApp;
    [self.scrollView addSubview:self.contentView];
    
    self.shareWeChatView = [[XBShareWeChatView alloc] init];
    self.shareWeChatView.delegate = self;
    [self.scrollView addSubview:self.shareWeChatView];
    
    
    self.commnetView = [UIView new];
    [self.scrollView addSubview:self.commnetView];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.text = @"评论";
    self.commentLabel.textColor = [UIColor blackColor];
    self.commentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];
    [self.commnetView addSubview:self.commentLabel];
    
    self.commentSeparatorView = [[UIView alloc] init];
    self.commentSeparatorView.backgroundColor = [UIColor colorWithHexString:@"#E4E4E4"];
    [self.commnetView addSubview:self.commentSeparatorView];
    
    self.commentTableView = [UITableView new];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    self.commentTableView.showsVerticalScrollIndicator = NO;
    self.commentTableView.showsHorizontalScrollIndicator = NO;
    self.commentTableView.scrollEnabled = NO;
    self.commentTableView.backgroundColor = self.scrollView.backgroundColor;
    [self.commentTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XBCommentCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuseIdentifier];
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.commentPrototype = [self.commentTableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [self addFooterView];
    [self.scrollView addSubview:self.commentTableView];
    
    [self addConstraint];
    
}

- (void)buildMenu
{
    if (![self.app isKindOfClass:[AppFavorite class]]) {
        self.appFavorite = [AppFavorite favoriteAppFromApp:self.app];
    } else {
        self.appFavorite = (AppFavorite *)self.app;
    }
    
    self.menuTitles = [NSMutableArray array];
    self.menuImages = [NSMutableArray array];
    
    if (self.homeRightType != XBHomeRightTypeArticle) {
        [self.menuTitles addObject:self.appFavorite.isFavorite ? @"已收藏" : @"收藏"];
        [self.menuImages addObject:[UIImage imageNamed:self.appFavorite.isFavorite ? @"detail_icon_fav_roll_normal" : @"detail_icon_fav_normal"]];
    }
    
    [self.menuTitles addObject:@"分享"];
    [self.menuImages addObject:[UIImage imageNamed:@"detail_icon_share_normal"]];
    
    if (self.homeRightType != XBHomeRightTypeArticle && self.app.downloadUrl.length > 0) {
        [self.menuImages addObject:[UIImage imageNamed:@"detail_icon_download_normal"]];
        [self.menuTitles addObject:@"下载"];
    }
    
    NSDictionary *data = @{@"images":self.menuImages,
                           @"titles":self.menuTitles
                           };
    self.menuView.data = data;
    
    //导航栏创建菜单
    [self buildNavigationBarMenu];
}

//创建导航菜单
- (void)buildNavigationBarMenu
{
    CGFloat menuHeight   = CGRectGetHeight(self.menuView.frame);
    CGFloat naviBarMenuY = 17;
    CGFloat naviBarMenuX = CGRectGetWidth(self.backButton.frame) * 1.8f;
    
    self.naviBarMenuView = [[XBMenuView alloc] initWithFrame:CGRectMake(naviBarMenuX, naviBarMenuY , CGRectGetWidth(self.view.frame) - naviBarMenuX * 2, menuHeight) images:self.menuImages type:XBMenuViewTypeNavBar];
    self.naviBarMenuView.delegate = self;
    self.naviBarMenuView.hidden = YES;
    self.naviBarMenuView.userInteractionEnabled = YES;
    [self.view addSubview:self.naviBarMenuView];
}

//设置约束
- (void)addConstraint
{
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat y = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(y);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.toolBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.bottom);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_offset(kToolBarH);
    }];
    
    CGFloat imageH = width * 0.578;
    [self.coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.mas_offset(imageH);
    }];
    
    [self.tempImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.coverImageView);
        make.width.equalTo(self.coverImageView.width);
        make.height.mas_offset(imageH);
    }];

    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.coverImageView.bottom);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(kIconWH + 10);
    }];
    
    [self.avatorImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView).offset(10.f);
        make.top.equalTo(self.headerView).offset(8.f);
        make.width.mas_equalTo(kIconWH);
        make.height.mas_equalTo(kIconWH);
    }];
    
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatorImageView);
        make.left.equalTo(self.avatorImageView.right).offset(10.f);
        make.width.equalTo(self.headerView.width).offset(-(kIconWH + 30));
        make.height.equalTo(self.avatorImageView);
    }];
    
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView).offset(5);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.titleView);
    }];
    
    [self.subTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom);
        make.left.equalTo(self.titleView);
        make.right.equalTo(self.titleView);
        make.height.equalTo(self.titleLabel.height);
    }];
    
    [self.menuView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.headerView.bottom);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.f);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.menuView.bottom);
        make.width.equalTo(self.scrollView.width);
    }];
    
    CGFloat shareHeight = CGRectGetWidth(self.view.frame) * 0.4;
    [self.shareWeChatView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10);
        make.top.equalTo(self.contentView.bottom).offset(20.f);
        make.width.equalTo(self.scrollView.width).offset(-20.f);
        make.height.mas_equalTo(shareHeight);
    }];
    
    CGFloat commentViewH = 30.f;
    [self.commnetView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(13.f);
        make.top.equalTo(self.shareWeChatView.bottom).offset(40.f);
        make.width.equalTo(self.scrollView.width).offset(-26.f);
        make.height.mas_equalTo(commentViewH);
    }];
    
    [self.commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commnetView);
        make.left.equalTo(self.commnetView).offset(5.f);
    }];
    
    [self.commentSeparatorView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.commnetView);
        make.left.equalTo(self.commentLabel.right).offset(5.f);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(1.f);
    }];
    
    [self.commentTableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commnetView.bottom).offset(25.f);
        make.left.equalTo(self.scrollView.left);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_greaterThanOrEqualTo(50.f);
        make.bottom.equalTo(self.scrollView.bottom);
    }];
}

- (void)menuAction
{
    [self.naviBarMenuView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [XBPushTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBPushTransitionTypePush : XBPushTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    //手势开始的时候才需要传入手势过渡代理，如果直接点击pop，应该传入空，否者无法通过点击正常pop
    return _interactiveTransition.interation ? _interactiveTransition : nil;
}


#pragma mark -- XBContentViewDelegate
- (void)contentAttributedLabel:(TTTAttributedLabel *)label
          didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark -- XBShareWeChatViewDelegate
- (void)shareWeChatViewDidSelected
{
    DDLogDebug(@"share to wechat");
}

#pragma mark -- XBMenuViewDelegate
- (void)menuView:(XBMenuView *)menuView didSelectedWithType:(XBMenuViewDidSelectedType)type atIndex:(NSInteger)index
{
    
    if (type == XBMenuViewDidSelectedTypeFavorite) {
        NSError *error = nil;
        BOOL result = [self.appFavorite toggleFavoriteWithOutError:&error];
        if (result) {
            
            UIImage *image = [UIImage imageNamed:self.appFavorite.isFavorite ? @"detail_icon_fav_roll_normal" : @"detail_icon_fav_normal"];
            [self.menuView replaceImage:image atIndex:index];
            [self.naviBarMenuView replaceImage:image atIndex:index];
            
            [self.menuView replaceTitle:self.appFavorite.isFavorite ? @"已收藏" : @"收藏" atIndex:0];
            
            NSString *tip = self.appFavorite.isFavorite ? @"已收藏此文章" : @"已取消对此文章的收藏";
            [[SMProgressHUD shareInstancetype] showTip:tip];
        }
        
    } else if (type == XBMenuViewDidSelectedTypeShare) {
        
        [self.shareView showWidthTargetViewController:self shareDataBlock:^ShareData *{
            return [ShareData shareWithImage:self.avatorImageView.image content:self.subTitleLabel.text url:@"http://www.baidu.com"];
        }];
        
    } else if (type == XBMenuViewDidSelectedTypeDownload) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.app.downloadUrl]];
    }
}

#pragma mark -- XBHomeToolBarDelegate
- (void)toolBarDidSelectedBeautiful:(XBHomeToolBar *)toolBar
{
    User *user = [self checkUserIsLogin];
    if (!user) return;
    
    if (self.isBeautiful) {
        [[SMProgressHUD shareInstancetype] showTip:@"已完成对此文章的美一下"];
        return;
    }
    
    [self showLoadinngInView:self.view];
    
    NSDictionary *params = @{
                             @"signature":@"1d2901dfec1ef2e57485c5dffd368913",
                             @"timestamp":@"1466153683",
                             @"user_id":[NSNumber numberWithInteger:user.uid]
                             };
    [[XBHttpClient shareInstance] upWithAppId:[self.app.modelId integerValue] params:params success:^(Info *info) {
        
        [[SMProgressHUD shareInstancetype] showTip:@"表态成功 ^_^"];
        
        self.app.info = info;
        
        [self checkIsBeautifulOrFeel];
        
        [self hideLoading];
        
    } failure:^(NSError *error) {
    
        [self hideLoading];
        
        [[SMProgressHUD shareInstancetype] showTip:@"表态失败 T_T"];
    
    }];
}

- (void)toolBarDidSelectedFeel:(XBHomeToolBar *)toolBar
{
    User *user = [self checkUserIsLogin];
    if (!user) return;
    
    if (self.isFeel) {
        [[SMProgressHUD shareInstancetype] showTip:@"已完成对此文章的一般般"];
        return;
    }
    
    [self showLoadinngInView:self.view];
    
    NSDictionary *params = @{
                             @"signature":@"1d2901dfec1ef2e57485c5dffd368913",
                             @"timestamp":@"1466153683",
                             @"user_id":[NSNumber numberWithInteger:user.uid]
                            };
    [[XBHttpClient shareInstance] downWithAppId:[self.app.modelId integerValue] params:params success:^(Info *info) {
        
        [[SMProgressHUD shareInstancetype] showTip:@"表态成功 ^_^"];
        
        self.app.info = info;
        
        [self checkIsBeautifulOrFeel];

        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [[SMProgressHUD shareInstancetype] showTip:@"表态失败 T_T"];
    
        [self hideLoading];
        
    }];
}

- (void)toolBarDidSelectedComment:(XBHomeToolBar *)toolBar
{
    if (![self checkUserIsLogin]) return;
    
    XBPublishCommentViewController *pcVC = [[XBPublishCommentViewController alloc] init];
    pcVC.app = self.app;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pcVC];
    
    [self presentViewController:navigationController animated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

#pragma mark -- UIScollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    if (self.coverHeight != self.coverImageView.xb_height) {
//        [self.coverImageView updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(self.coverHeight);
//        }];
//        
//    }
    
//    DDLogDebug(@"scrollViewDidEndDragging");
}

- (void)scrollViewDidEndDecelerating
{
//    DDLogDebug(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //计算封面图片进行缩放
    CGFloat offsetY = self.scrollView.contentOffset.y;
//    if (offsetY < 0) {
//        [self.coverImageView updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(self.coverImageView.xb_height + fabsf(offsetY));
//        }];
//    }
    
//    DDLogDebug(@"offsetY:%f",offsetY);
    
    //封面进行滚动
    if (offsetY > 0 && offsetY <= self.coverImageView.xb_height) {
        
        self.coverImageView.hidden = YES;
        
        self.tempImageView.hidden = NO;
        
//        if (self.previousOffsetY < offsetY) { //向上
////            self.tempImageView.xb_y -=  0.45f;
//            self.tempImageView.xb_y -=  offsetY * 0.015f;
//            
//            DDLogDebug(@"xb_y:%f",self.tempImageView.xb_y);
//            
//        } else {
////             self.tempImageView.xb_y +=  self.tempImageView.xb_y == 20 ? 0 : 0.45f;
//            self.tempImageView.xb_y +=  offsetY * 0.015f;
//        }
        
        
    } else {
        
        self.coverImageView.hidden = NO;
        
        self.tempImageView.hidden = YES;
        
    }
    
    self.previousOffsetY = offsetY;
    
    //设置菜单栏动画
    CGFloat menuOffsetY = [self.menuView convertRect:self.menuView.bounds toView:self.view].origin.y;
    BOOL isHideMenu = menuOffsetY <= CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    if (isHideMenu && self.naviBarMenuView.hidden) {
        //导航栏显示
        self.naviBarMenuView.hidden = !isHideMenu;
        self.menuView.hidden = isHideMenu;
        [self.naviBarMenuView showWithComplete:^(BOOL finished) {
            
            UIImageView *firstView = [self.menuView.subviews firstObject];
            UILabel *firstLabel    = self.menuView.subviews[1];
            
            //非文章专栏时显示
            if ([self.naviBarMenuView.subviews count] != 1) {
                
                UIImageView *lastView  = self.menuView.subviews[self.menuView.subviews.count - 2];
                UILabel *lastLabel     = [self.menuView.subviews lastObject];
                
                
                //设置偏移量
                firstView.mj_x  += kAnimationSpace;
                firstLabel.mj_x += kAnimationSpace;
                lastView.mj_x   -= kAnimationSpace;
                lastLabel.mj_x  -= kAnimationSpace;
                
            } else {
                
                //设置偏移量
                firstView.mj_x  -= kAnimationSpace;
                firstLabel.mj_x -= kAnimationSpace;
            }
            
            //隐藏收藏、分享、下载
            for (UIView *view in self.menuView.subviews) {
                if ([view isKindOfClass:[UILabel class]]) {
                    view.alpha = 0.f;
                }
            }
        }];
    } else if (!isHideMenu && self.menuView.hidden) {
        
        self.naviBarMenuView.hidden = !isHideMenu;
        self.menuView.hidden = isHideMenu;
        
        [self.naviBarMenuView hideWithComplete:^(BOOL finished) {
            
            UIImageView *firstView = [self.menuView.subviews firstObject];
            UIImageView *lastView  = self.menuView.subviews[self.menuView.subviews.count - 2];
            UILabel *firstLabel    = self.menuView.subviews[1];
            UILabel *lastLabel     = [self.menuView.subviews lastObject];
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                //非文章专栏时显示
                if ([self.naviBarMenuView.subviews count] != 1) {
                    
                    //设置成原来的偏移量
                    firstView.mj_x  -= kAnimationSpace;
                    firstLabel.mj_x -= kAnimationSpace;
                    lastView.mj_x   += kAnimationSpace;
                    lastLabel.mj_x  += kAnimationSpace;
                    
                } else {
                    //设置偏移量
                    firstView.mj_x  += kAnimationSpace;
                    firstLabel.mj_x += kAnimationSpace;
                }
                
                //显示收藏、分享、下载
                for (UIView *view in self.menuView.subviews) {
                    if ([view isKindOfClass:[UILabel class]]) {
                        view.alpha = 1.f;
                    }
                }
                
            } completion:nil];
            
        }];
    }
    
    
    //滚动到tableview的位置并且有评论、有更多数据才加载评论
    BOOL isLoad   = scrollView.contentOffset.y >= scrollView.contentSize.height - CGRectGetHeight(self.view.frame);
    BOOL isNoData = self.commentTableViewFooter.previousState == MJRefreshStateNoMoreData;
    if (isLoad && !isNoData) {
        [self.commentTableView.mj_footer beginRefreshing];
    }

    //计算工具栏在什么时候进行滚动
    BOOL isScroll = scrollView.contentOffset.y >= scrollView.contentSize.height * 0.57;
    CGFloat toolBarW = CGRectGetWidth(self.toolBar.frame);
    CGFloat toolBarH = CGRectGetHeight(self.toolBar.frame);
    if (isScroll) {
        if (!self.toolBar.isScroll) {
            [self.toolBar scrollRectToVisible:CGRectMake(toolBarW, 0, toolBarW, toolBarH) animated:YES];
            self.toolBar.isScroll = YES;
        }
    } else {
        if (self.toolBar.isScroll) {
            [self.toolBar scrollRectToVisible:CGRectMake(0, 0, toolBarW, toolBarH) animated:YES];
            self.toolBar.isScroll = NO;
        }
    }
    
}

#pragma mark -- UITableView reloadData

- (void)addFooterView
{
    self.commentTableViewFooter = [XBRefreshAutoFooter footerWithRefreshingBlock:^{
        
        
        [[XBHttpClient shareInstance] getCommentWithAppId:[self.app.modelId integerValue] page:self.commnetPage pageSize:self.commentPageSize success:^(NSArray *datas) {
            
            if (datas && datas.count > 0) {
                if (self.datas.count <= 0) {
                    self.datas = datas;
                } else {
                    self.datas = [self.datas arrayByAddingObjectsFromArray:datas];
                }
                
                [self.commentTableView.mj_footer endRefreshing];
                [self.commentTableView reloadData];
                
                //更新UITableView的高度
                if (self.commentTableView.contentSize.height > CGRectGetHeight(self.commentTableView.frame)) {
                    [self.commentTableView updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(self.commentTableView.contentSize.height + 40);
                    }];
                }
                
                self.commnetPage += 1;
                
            } else {
                
                if (self.datas.count > 0) {
                    [self.commentTableView updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(self.commentTableView.contentSize.height - 5);
                    }];
                } else {
                    //如果没有评论则不显示
                    self.commnetView.hidden = YES;
                    self.commentTableView.hidden = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame),(CGRectGetMaxY(self.shareWeChatView.frame)));
                    });
                }
                [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } failure:^(NSError *error) {
            [self showFail:@"获取数据失败...." inView:self.view];
            [self.commentTableView.mj_footer endRefreshing];
        }];
        
        
    }];
    
    self.commentTableView.mj_footer = self.commentTableViewFooter;
}



#pragma mark -- UITableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.comment  = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 80;
    Comment *comment = self.datas[indexPath.row];
    self.commentPrototype.contentLabel.text = comment.content;
    CGFloat height = CGRectGetHeight(self.commentPrototype.contentLabel.frame);
    NSString *content = [comment.content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    CGSize size = [content sizeWithFont:self.commentPrototype.contentFont maxSize:CGSizeMake(CGRectGetWidth(self.commentPrototype.contentLabel.frame), NSIntegerMax)];
    result += size.height > height ? size.height + height : 0;
    return result;
}

#pragma mark -- XBCommentCellDelegate
- (void)commentCellDidSelectLinkWithURL:(NSURL *)url
{
    XBWebViewController *webViewController = [[XBWebViewController alloc] init];
    webViewController.url = url;
    webViewController.hideToolBar = YES;
    [self presentViewController:webViewController animated:YES completion:nil];
}

#pragma mark -- lazy loading
- (XBShareView *)shareView
{
    if (!_shareView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        _shareView = [[XBShareView alloc] initWithFrame:keyWindow.bounds];
        [keyWindow addSubview:_shareView];
    }
    return _shareView;
}

#pragma mark -- public method
- (User *)checkUserIsLogin
{
    User *user = [XBUserDefaultsUtil userInfo];
    if (!user) {
        [self presentViewController:[[XBLoginViewController alloc] init] animated:YES completion:nil];
        return nil;
    }
    return user;
}

- (void)checkIsBeautifulOrFeel
{
    User *user = [self checkUserIsLogin];
    if (!user) return;
    
    Info *info = self.app.info;
    NSArray *users = [info.upUsers isKindOfClass:[NSData class]] ? [info unarchiveObjectWithDataFromUpUsers] : info.upUsers;
    for (NSString *userId in users) {
        if (user.uid == [userId integerValue]) {
            self.beautiful = YES;
            self.feel = NO;
        }
    }
    
    NSArray *downUsers = [info.downUsers isKindOfClass:[NSData class]] ? [info unarchiveObjectWithDataFromDownUsers] : info.downUsers;
    for (NSString *userId in downUsers) {
        if (user.uid == [userId integerValue]) {
            self.feel = YES;
            self.beautiful = NO;
        }
    }
    
    self.toolBar.voteLabel.text = [NSIntegerFormatter formatToNSString:users.count];
    if (self.isBeautiful) {
        
        self.toolBar.voteImageView.image = [UIImage imageNamed:@"detail_icon_flower_selected"];
        self.toolBar.voteTitleLabel.text = @"美过了";
        
        UIFont *titleFont = self.toolBar.voteTitleLabel.font;
        self.toolBar.voteTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:titleFont.pointSize];
    
    } else {
        
        self.toolBar.voteImageView.image = [UIImage imageNamed:@"detail_icon_flower_normal"];
        self.toolBar.voteTitleLabel.text = @"美一下";
        
        UIFont *titleFont = self.toolBar.voteTitleLabel.font;
        self.toolBar.voteTitleLabel.font = [UIFont systemFontOfSize:titleFont.pointSize];
    }
    
    if (self.isFeel) {
        
        self.toolBar.greenImageView.image = [UIImage imageNamed:@"detail_icon_leaf_selected"];
        self.toolBar.greenLabel.text = @"已表态";
        
        UIFont *greenFont = self.toolBar.greenLabel.font;
        self.toolBar.greenLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:greenFont.pointSize];
        
    } else {
        
        self.toolBar.greenImageView.image = [UIImage imageNamed:@"detail_icon_leaf_normal"];
        self.toolBar.greenLabel.text = @"一般般";
        
        UIFont *greenFont = self.toolBar.greenLabel.font;
        self.toolBar.greenLabel.font = [UIFont systemFontOfSize:greenFont.pointSize];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
