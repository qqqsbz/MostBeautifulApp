//
//  XBHomeCommonViewController.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XBHomeCell;
#import "XBHomeRightButton.h"
#import "XBSlideCardView.h"
@interface XBHomeCommonViewController : UIViewController

@property (strong, nonatomic) XBHomeRightButton *homeRightButton;

@property (assign, nonatomic) XBHomeRightType  homeRightType;

@property (assign, nonatomic) NSInteger  page;

@property (assign, nonatomic) NSInteger  pageSize;

@property (strong, nonatomic) NSArray  *datas;

@property (strong, nonatomic) XBSlideCardView   *cardView;

@property (assign, nonatomic) BOOL  showMenu;

- (XBHomeCell *)currentHomeCell;

- (void)reloadData;

- (void)resetBackgroundColorIsScrollToItem:(BOOL)isScroll;

- (void)menuAction;

@end
