//
//  XBSearchViewController.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XBSearchViewController : UIViewController
/** UITableView 获取cell */
@property (strong, nonatomic) UITableView  *tableView;

/** 当前选中的IndexPath */
@property (strong, nonatomic) NSIndexPath  *currentIndexPath;

@end
