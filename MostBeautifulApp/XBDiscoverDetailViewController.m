//
//  XBDiscoverDetailViewController.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kAnimationSpace 25.f

#import "XBDiscoverDetailViewController.h"
#import "User.h"
#import "App.h"
#import "Author.h"
#import "Comment.h"
#import "XBMenuView.h"
#import "XBContentView.h"
#import "XBHomeToolBar.h"
#import "XBCommentCell.h"
#import "NSString+Util.h"
#import "XBUserDefaultsUtil.h"
#import "XBRefreshAutoFooter.h"
#import "XBDiscoverBeautifulView.h"
#import "XBDiscoverHeaderView.h"
#import "XBInteractiveTransition.h"
#import "XBDiscoverPushTransition.h"
#import "XBLoginViewController.h"
#import "XBPublishCommentViewController.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>
#import <MJRefresh/UIView+MJExtension.h>
@interface XBDiscoverDetailViewController () <XBMenuViewDelegate,XBContentViewDelegate,XBHomeToolBarDelegate,XBDiscoverBeautifulViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIScrollView          *scrollView;
@property (strong, nonatomic) XBHomeToolBar         *toolBar;
@property (strong, nonatomic) XBMenuView            *menuView;
@property (strong, nonatomic) XBMenuView            *naviBarMenuView;
@property (strong, nonatomic) XBContentView         *contentView;
@property (strong, nonatomic) UIView                *commnetView;
@property (strong, nonatomic) UILabel               *commentLabel;
@property (strong, nonatomic) UIView                *commentSeparatorView;
@property (strong, nonatomic) UITableView           *commentTableView;
@property (strong, nonatomic) XBCommentCell         *commentPrototype;
@property (strong, nonatomic) XBRefreshAutoFooter   *commentTableViewFooter;
@property (strong, nonatomic) XBDiscoverHeaderView  *headerView;
@property (strong, nonatomic) XBDiscoverBeautifulView  *beautifulView;
/** 手势 */
@property (strong, nonatomic) XBInteractiveTransition  *interactiveTransition;

/** 是否"美一下" */
@property (assign, nonatomic,getter=isBeautiful) BOOL  beautiful;
/** 是否"一般般" */
@property (assign, nonatomic,getter=isFeel)      BOOL  feel;
/** 评论页数 */
@property (assign, nonatomic) NSInteger     commentPageSize;
/** 评论数据*/
@property (strong, nonatomic) NSArray       *datas;
/** 菜单图标 */
@property (strong, nonatomic) NSArray  *menuImages;
@end

static NSString *reuseIdentifier = @"XBCommentCell";
@implementation XBDiscoverDetailViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.commentPageSize = 5;
        
        [self buildView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
//    //初始化手势过渡的代理
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

- (void)setDiscover:(Discover *)discover
{
    _discover = discover;
    
    //设置抬头信息
    self.headerView.nameLabel.text = discover.authorName;
    self.headerView.plantformLabel.text = discover.authorCareer;
    self.headerView.titleLabel.text = discover.title;
    [self.headerView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:discover.authorAvatarUrl]];
    [self.headerView.iconImageView sd_setImageWithURL:[NSURL URLWithString:discover.iconImage]];
    
    //设置按钮
    [self fillMenu];
    
    [self checkIsBeautifulOrFeel];
    
    //给出html格式 让系统进行解析并创建子view
    NSString *content = [[NSString stringWithFormat:@"<p>%@</p>",discover.desc] stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    for (NSString *imageUrl in discover.allImages) {
        NSString *image = [NSString stringWithFormat:@"<img src=\"%@\" />",imageUrl];
        content = [content stringByAppendingString:image];
    }
    self.contentView.text = content;
    
    //更新content的长度
    [self.contentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(self.contentView.frame));
    }];
    
    //如果美过的人少于 kDiscoverBeautifulRowCount 则重新设置新的高度 该高度为原来高度的0.85倍
    if (self.discover.upUsers.count < kDiscoverBeautifulRowCount) {
        [self.beautifulView updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(kDiscoverHeaderHeight * 0.85);
        }];
    }
    
    //如果没有美过的人则不显示
    if (self.discover.upUsers.count <= 0) {
        [self.beautifulView updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
    } else {
        //加载美过的人
        [self.beautifulView reloadData];
    }
    
    //如果没有评论则不显示
    if (self.discover.comments.count <= 0) {
        self.commnetView.hidden = YES;
        self.commentTableView.hidden = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame),(CGRectGetMaxY(self.beautifulView.frame)));
        });
    }
    
}

//创建视图
- (void)buildView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(8, 30, 35.f, 35.f);
    [backButton setImage:[UIImage imageNamed:@"detail_icon_back_normal"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self.view addSubview:self.scrollView];
    
    self.toolBar = [XBHomeToolBar new];
    self.toolBar.toolBarDelegate = self;
    [self.view addSubview:self.toolBar];
    
    self.headerView = [XBDiscoverHeaderView new];
    [self.scrollView addSubview:self.headerView];
    
    self.menuView = [XBMenuView new];
    self.menuView.delegate = self;
    [self.scrollView addSubview:self.menuView];
    
    self.contentView = [XBContentView new];
    self.contentView.delegate = self;
    self.contentView.type     = XBContentViewTypeDiscover;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self.scrollView addSubview:self.contentView];
    
    self.beautifulView = [XBDiscoverBeautifulView new];
    self.beautifulView.datasource = self;
    self.beautifulView.backgroundColor = [UIColor colorWithHexString:@"#F6F6F6"];
    [self.scrollView addSubview:self.beautifulView];
    
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
    
    
    [self addConstraints];
}

//设置约束
- (void)addConstraints
{
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.toolBar makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.scrollView.bottom);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_offset(kToolBarH);
    }];
    
    [self.headerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView).offset(44);
        make.width.equalTo(self.scrollView);
        make.height.mas_offset(kDiscoverHeaderHeight);
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
    
    [self.beautifulView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.bottom).offset(40.f);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.mas_offset(kDiscoverBeautifulHeight);
    }];
    
    CGFloat commentViewH = 30.f;
    [self.commnetView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(13.f);
        make.top.equalTo(self.beautifulView.bottom).offset(20.f);
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

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//设置菜单栏数据
- (void)fillMenu
{
    self.menuImages = @[
                        [UIImage imageNamed:@"detail_icon_share_normal"],
                        [UIImage imageNamed:@"detail_icon_download_normal"]
                       ];
    
    NSDictionary *data = @{@"images":self.menuImages,
                           @"titles":@[@"分享",@"下载"]
                           };
    self.menuView.data = data;
    
    [self buildNavigationBarMenu];
}

//创建导航菜单
- (void)buildNavigationBarMenu
{
    self.naviBarMenuView = [[XBMenuView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.menuView.frame)) images:self.menuImages type:XBMenuViewTypeNavBar];
    self.naviBarMenuView.delegate = self;
    self.naviBarMenuView.hidden = YES;
    self.naviBarMenuView.userInteractionEnabled = YES;
    self.navigationItem.titleView.userInteractionEnabled = YES;
    self.navigationItem.titleView = self.naviBarMenuView;
}


#pragma mark -- UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
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
    if ((isLoad && self.discover.comments.count > 0) && !isNoData) {
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

- (void)addFooterView
{
    self.commentTableViewFooter = [XBRefreshAutoFooter footerWithRefreshingBlock:^{
        
        NSInteger commentId = -1;
        
        if (self.datas.count > 0) {
            Comment *comment = [self.datas lastObject];
            commentId = [comment.modelId integerValue];
        }
        [[XBHttpClient shareInstance] getCommentWithDiscoverId:[self.discover.modelId integerValue] commentId:commentId pageSize:self.commentPageSize success:^(NSArray *datas) {
            
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
                
            } else {
                
                //如果有数据并且无更多数据 缩进footer的宽度
                if (self.datas.count > 0) {
                    [self.commentTableView updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(self.commentTableView.contentSize.height - 5);
                    }];
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


#pragma mark -- XBMenuView delegate
- (void)menuView:(XBMenuView *)menuView didSelectedWithType:(XBMenuViewDidSelectedType)type atIndex:(NSInteger)index
{
    
}

#pragma mark -- XBContentViewDelegate
- (void)contentAttributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{

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
                             @"app_id":[NSNumber numberWithInteger:[self.discover.modelId integerValue]],
                             @"signature":@"1d2901dfec1ef2e57485c5dffd368913",
                             @"timestamp":@"1466153683",
                             @"user_id":[NSNumber numberWithInteger:user.uid]
                             };
    
    [[XBHttpClient shareInstance] discoverUpWithParams:params success:^(NSArray *authors) {
        
        [[SMProgressHUD shareInstancetype] showTip:@"表态成功 ^_^"];
        
        self.discover.upUsers = authors;
        
        self.discover.downUsers = nil;
        
        [self checkIsBeautifulOrFeel];
        
        [self hideLoading];
        
        [self.beautifulView reloadData];
        
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
                             @"app_id":[NSNumber numberWithInteger:[self.discover.modelId integerValue]],
                             @"signature":@"1d2901dfec1ef2e57485c5dffd368913",
                             @"timestamp":@"1466153683",
                             @"user_id":[NSNumber numberWithInteger:user.uid]
                             };
    
    [[XBHttpClient shareInstance] discoverDownWithParams:params success:^(NSArray *authors) {
        
        
        [[SMProgressHUD shareInstancetype] showTip:@"表态成功 ^_^"];
        
        self.discover.downUsers = authors;
        
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.discover.upUsers];
        for (Author *author in self.discover.upUsers) {
            if ([author.modelId integerValue] == user.uid) {
                [temp removeObject:author];
            }
        }
        
        self.discover.upUsers = temp;
        
        [self checkIsBeautifulOrFeel];
        
        [self hideLoading];
        
        [self.beautifulView reloadData];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        
        [[SMProgressHUD shareInstancetype] showTip:@"表态失败 T_T"];
    
    }];
}

- (void)toolBarDidSelectedComment:(XBHomeToolBar *)toolBar
{
    if (![self checkUserIsLogin]) return;
    
    XBPublishCommentViewController *pcVC = [[XBPublishCommentViewController alloc] init];
    pcVC.discover = self.discover;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pcVC];
    [self presentViewController:navigationController animated:YES completion:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }];
}

#pragma mark -- XBDiscoverBeautifulViewDataSource
- (NSInteger)numberOfItemsInBeautifulView
{
    return self.discover.upUsers.count;
}

- (NSString *)discoverBeautifulView:(XBDiscoverBeautifulView *)discoverBeautifulView itemForRowAtIndex:(NSInteger)index
{
    Author *author =  self.discover.upUsers[index];
    return author.avatarUrl;
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


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [XBDiscoverPushTransition transitionWithTransitionType:operation == UINavigationControllerOperationPush ? XBDiscoverPushTransitionTypePush : XBDiscoverPushTransitionTypePop];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    //手势开始的时候才需要传入手势过渡代理，如果直接点击pop，应该传入空，否者无法通过点击正常pop
    return _interactiveTransition.interation ? _interactiveTransition : nil;
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
    
    for (Author *author in self.discover.upUsers) {
        if (user.uid == [author.modelId integerValue]) {
            self.beautiful = YES;
            self.feel = NO;
        }
    }

    for (Author *author in self.discover.downUsers) {
        if (user.uid == [author.modelId integerValue]) {
            self.feel = YES;
            self.beautiful = NO;
        }
    }

    self.toolBar.voteLabel.text = [NSIntegerFormatter formatToNSString:self.discover.upUsers.count];
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
