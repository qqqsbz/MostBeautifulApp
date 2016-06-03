//
//  HomeDetailViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/26.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kIconWH 52.f
#define kToolBarH 45.f
#define kAnimationSpace 25.f
#import "XBHomeDetailViewController.h"
#import "App.h"
#import "Comment.h"
#import "Comments.h"
#import "XBContentView.h"
#import "XBShareWeChatView.h"
#import "XBPushTransition.h"
#import "XBMenuView.h"
#import "XBHomeToolBar.h"
#import "XBScrollView.h"
#import "XBCommentCell.h"
#import "NSString+Util.h"
#import "XBRefreshAutoFooter.h"
#import "AppFavorite.h"
#import "SMProgressHUD.h"
#import <MJRefresh/MJRefresh.h>
@interface XBHomeDetailViewController () <XBContentViewDelegate,XBMenuViewDelegate,XBHomeToolBarDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) XBShareWeChatView  *shareView;
@property (strong, nonatomic) XBMenuView         *naviBarMenuView;
@property (strong, nonatomic) UIView             *commnetView;
@property (strong, nonatomic) UILabel            *commentLabel;
@property (strong, nonatomic) UIView             *commentSeparatorView;
@property (strong, nonatomic) NSArray            *datas;
@property (strong, nonatomic) UITableView        *commentTableView;
@property (strong, nonatomic) XBCommentCell      *commentPrototype;
@property (strong, nonatomic) NSMutableArray     *menuImages;
@property (strong, nonatomic) NSMutableArray     *menuTitles;
@property (strong, nonatomic) AppFavorite        *appFavorite;
@end

static NSString *reuseIdentifier = @"XBCommentCell";
@implementation XBHomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self buildView];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;;
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
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:app.coverImage]];
    
    [self buildMenu];
    
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(self.contentView.frame));
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = CGRectGetMaxY(self.commentTableView.frame) + 20.f;
        [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame), height)];
    });
}

//创建控件
- (void)buildView
{
    CGFloat y = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGRect frame = CGRectMake(0, y , CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - y -kToolBarH);

    self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    self.toolBar = [[XBHomeToolBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), CGRectGetWidth(self.view.frame), kToolBarH)];
    self.toolBar.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    self.toolBar.toolBarDelegate = self;
    [self.view addSubview:self.toolBar];
    
    self.coverImageView = [UIImageView new];
    [self.scrollView addSubview:self.coverImageView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 35.f, 35.f);
    [self.backButton setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    self.avatorImageView = [UIImageView new];
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius  = 12.;
    [self.scrollView addSubview:self.avatorImageView];
    
    self.titleView = [UIView new];
    [self.scrollView addSubview:self.titleView];
    
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
    [self.scrollView addSubview:self.menuView];
    
    self.contentView = [XBContentView new];
    self.contentView.delegate = self;
    [self.scrollView addSubview:self.contentView];
    
    self.shareView = [[XBShareWeChatView alloc] initWithDidSelectedBlock:^{
        DDLogDebug(@"share......");
    }];
    [self.scrollView addSubview:self.shareView];
    
    
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
    self.appFavorite = [AppFavorite favoriteAppFromApp:self.app];
    
    self.menuImages = [NSMutableArray arrayWithObjects:
                       [UIImage imageNamed:self.appFavorite.isFavorite ? @"detail_icon_fav_roll_normal" : @"detail_icon_fav_normal"],
                       [UIImage imageNamed:@"detail_icon_share_normal"],
                       nil];
    self.menuTitles = [NSMutableArray arrayWithObjects:self.appFavorite.isFavorite ? @"已收藏" : @"收藏",
                       @"分享", nil];
    
    if (self.app.downloadUrl.length > 0) {
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
    self.naviBarMenuView = [[XBMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.menuView.frame)) images:self.menuImages type:XBMenuViewTypeNavBar];
    self.naviBarMenuView.hidden = YES;
    self.navigationItem.titleView = self.naviBarMenuView;
}

//设置约束
- (void)addConstraint
{
    CGFloat width = CGRectGetWidth(self.view.frame);
    
    [self.coverImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.mas_offset(width * 0.578);
    }];
    
    
    [self.avatorImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10.f);
        make.top.equalTo(self.coverImageView.bottom).offset(10.f);
        make.width.mas_equalTo(kIconWH);
        make.height.mas_equalTo(kIconWH);
    }];
    
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatorImageView);
        make.left.equalTo(self.avatorImageView.right).offset(10.f);
        make.width.equalTo(self.scrollView.width).offset(-(kIconWH + 30));
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
        make.top.equalTo(self.titleView.bottom);
        make.width.equalTo(self.scrollView.width);
        make.height.mas_equalTo(50.f);
    }];
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.menuView.bottom);
        make.width.equalTo(self.scrollView.width);
    }];
    
    CGFloat shareHeight = CGRectGetWidth(self.view.frame) * 0.4;
    [self.shareView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10);
        make.top.equalTo(self.contentView.bottom).offset(20.f);
        make.width.equalTo(self.scrollView.width).offset(-20.f);
        make.height.mas_equalTo(shareHeight);
    }];

    CGFloat commentViewH = 30.f;
    [self.commnetView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(13.f);
        make.top.equalTo(self.shareView.bottom).offset(40.f);
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [XBPushTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBPushTransitionTypePush : XBPushTransitionTypePop];
}

#pragma mark -- XBContentViewDelegate
- (void)contentAttributedLabel:(TTTAttributedLabel *)label
          didSelectLinkWithURL:(NSURL *)url
{
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark -- XBMenuViewDelegate
- (void)menuView:(XBMenuView *)menuView didSelectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        NSError *error = nil;
        BOOL result = [self.appFavorite toggleFavoriteWithOutError:&error];
        if (result) {
            [self.menuView replaceImage:[UIImage imageNamed:self.appFavorite.isFavorite ? @"detail_icon_fav_roll_normal" : @"detail_icon_fav_normal"] atIndex:index];
            [self.menuView replaceTitle:self.appFavorite.isFavorite ? @"已收藏" : @"收藏" atIndex:0];
            
            NSString *tip = self.appFavorite.isFavorite ? @"已收藏此文章" : @"已取消对此文章的收藏";
            [[SMProgressHUD shareInstancetype] showTip:tip];
        }
        
    } else if (index == 1) {
        
    } else if (index == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.app.downloadUrl]];
    }
}

#pragma mark -- XBHomeToolBarDelegate
- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedBeautiful:(UIImageView *)imageView
{
    DDLogDebug(@"Beautiful");
}

- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedFeel:(UIImageView *)imageView
{
    DDLogDebug(@"Feel");
}

- (void)toolBar:(XBHomeToolBar *)toolbar didSelectedComment:(UILabel *)commentLabel
{
    DDLogDebug(@"Comment");
}

#pragma mark -- UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.commentTableView) return;
    //计算封面图片进行缩放
    
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    scaleAnimation.fromValue = @1.f;
//    scaleAnimation.toValue  = @2.f;
//    scaleAnimation.duration = 0.25f;
//    scaleAnimation.fillMode = kCAFillModeForwards;
//    scaleAnimation.removedOnCompletion = NO;
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    [self.coverImageView.layer addAnimation:scaleAnimation forKey:@"scale"];
    
    //设置菜单栏动画
    CGFloat menuOffsetY = [self.menuView convertRect:self.menuView.bounds toView:self.view].origin.y;
    BOOL isHideMenu = menuOffsetY <= CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    if (isHideMenu && self.naviBarMenuView.hidden) {
        //导航栏显示
        self.naviBarMenuView.hidden = !isHideMenu;
        self.menuView.hidden = isHideMenu;
        [self.naviBarMenuView showWithComplete:^(BOOL finished) {
            
            UIImageView *firstView = [self.menuView.subviews firstObject];
            UIImageView *lastView  = self.menuView.subviews[self.menuView.subviews.count - 2];
            UILabel *firstLabel    = self.menuView.subviews[1];
            UILabel *lastLabel     = [self.menuView.subviews lastObject];
            
            //设置偏移量
            firstView.mj_x  += kAnimationSpace;
            firstLabel.mj_x += kAnimationSpace;
            lastView.mj_x   -= kAnimationSpace;
            lastLabel.mj_x  -= kAnimationSpace;
            
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
            
                //设置成原来的偏移量
                firstView.mj_x  -= kAnimationSpace;
                firstLabel.mj_x -= kAnimationSpace;
                lastView.mj_x   += kAnimationSpace;
                lastLabel.mj_x  += kAnimationSpace;
                
                //显示收藏、分享、下载
                for (UIView *view in self.menuView.subviews) {
                    if ([view isKindOfClass:[UILabel class]]) {
                        view.alpha = 1.f;
                    }
                }
                
            } completion:nil];
            
        }];
    }
    
    //加载评论
    BOOL isLoad = scrollView.contentOffset.y >= scrollView.contentSize.height - CGRectGetHeight(self.view.frame);
    if (isLoad) {
        [self.commentTableView.mj_footer beginRefreshing];
    }
    
    //计算工具栏在什么时候进行滚动
    BOOL isScroll = scrollView.contentOffset.y >= scrollView.contentSize.height * 0.57;
    CGFloat toolBarW = CGRectGetWidth(self.toolBar.frame);
    CGFloat toolBarH = CGRectGetHeight(self.toolBar.frame);
    if (isScroll) {
        if (self.toolBar.isScroll) return;
        [self.toolBar scrollRectToVisible:CGRectMake(toolBarW, 0, toolBarW, toolBarH) animated:YES];
        self.toolBar.isScroll = YES;
    } else {
        if (!self.toolBar.isScroll) return;
        [self.toolBar scrollRectToVisible:CGRectMake(0, 0, toolBarW, toolBarH) animated:YES];
        self.toolBar.isScroll = NO;
    }
    
}

#pragma mark -- UITableView reloadData

- (void)addFooterView
{
    self.commentTableView.mj_footer = [XBRefreshAutoFooter footerWithRefreshingBlock:^{
        if (self.datas.count <= 0) {
            self.datas = self.app.comments.data;
            if (self.datas.count > 0) {
                [self.commentTableView.mj_footer endRefreshing];
                [self.commentTableView reloadData];
            } else {
                [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } else {
            //访问网络 获取数据
            [self.commentTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        //更新UITableView的高度
        if (self.commentTableView.contentSize.height > CGRectGetHeight(self.commentTableView.frame)) {
            [self.commentTableView updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.commentTableView.contentSize.height + 50);
            }];
        }
    }];
}



#pragma mark -- UITableView data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.comment = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat result = 80;
    Comment *comment = self.datas[indexPath.row];
    self.commentPrototype.contentLabel.text = comment.content;
    CGFloat height = CGRectGetHeight(self.commentPrototype.contentLabel.frame);
    NSString *content = [comment.content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    CGSize size = [content sizeWithFont:self.commentPrototype.contentLabel.font maxSize:CGSizeMake(CGRectGetWidth(self.commentPrototype.contentLabel.frame), NSIntegerMax)];
    result += size.height > height ? size.height + height : 0;
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
