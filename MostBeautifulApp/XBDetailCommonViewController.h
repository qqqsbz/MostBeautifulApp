//
//  XBCommonViewController.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBMenuView.h"
#import "XBHomeRightButton.h"
@class App;
@class XBContentView;
@class XBHomeToolBar;
@class XBScrollView;
@class AppFavorite;
@class XBShareWeChatView;
@class XBShareView;
@class TTTAttributedLabel;
@interface XBDetailCommonViewController : UIViewController

@property (strong, nonatomic) UIButton          *backButton;
@property (strong, nonatomic) UIView            *titleView;
@property (strong, nonatomic) UILabel           *titleLabel;
@property (strong, nonatomic) UILabel           *subTitleLabel;
@property (strong, nonatomic) XBMenuView        *menuView;
@property (strong, nonatomic) UIImageView       *coverImageView;
@property (strong, nonatomic) UIImageView       *avatorImageView;
@property (strong, nonatomic) UIScrollView      *scrollView;
@property (strong, nonatomic) XBHomeToolBar     *toolBar;
@property (strong, nonatomic) XBContentView     *contentView;
@property (strong, nonatomic) XBShareWeChatView *shareWeChatView;
@property (strong, nonatomic) XBShareView       *shareView;

@property (strong, nonatomic) App           *app;
@property (strong, nonatomic) AppFavorite   *appFavorite;
@property (assign, nonatomic) XBHomeRightType  homeRightType;

- (void)shareWeChatViewDidSelected;

- (void)contentAttributedLabel:(TTTAttributedLabel *)label
          didSelectLinkWithURL:(NSURL *)url;

- (void)menuView:(XBMenuView *)menuView
        didSelectedWithType:(XBMenuViewDidSelectedType)type
        atIndex:(NSInteger)index;

- (void)toolBar:(XBHomeToolBar *)toolbar
            didSelectedBeautiful:(UIImageView *)imageView;

- (void)toolBar:(XBHomeToolBar *)toolbar
            didSelectedFeel:(UIImageView *)imageView;

- (void)toolBar:(XBHomeToolBar *)toolbar
            didSelectedComment:(UILabel *)commentLabel;
@end
