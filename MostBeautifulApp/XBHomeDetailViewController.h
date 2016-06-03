//
//  HomeDetailViewController.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/26.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class App;
@class XBContentView;
@class XBMenuView;
@class XBHomeToolBar;
@class XBScrollView;
@interface XBHomeDetailViewController : UIViewController <UINavigationControllerDelegate>
@property (strong, nonatomic) UIScrollView  *scrollView;
@property (strong, nonatomic) UIButton      *backButton;
@property (strong, nonatomic) UIImageView   *coverImageView;
@property (strong, nonatomic) UIImageView   *avatorImageView;
@property (strong, nonatomic) UIView        *titleView;
@property (strong, nonatomic) UILabel       *titleLabel;
@property (strong, nonatomic) UILabel       *subTitleLabel;
@property (strong, nonatomic) XBMenuView    *menuView;
@property (strong, nonatomic) XBContentView *contentView;
@property (strong, nonatomic) XBHomeToolBar      *toolBar;
@property (strong, nonatomic) App  *app;
@end
