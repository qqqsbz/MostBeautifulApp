//
//  HomeViewController.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBHomeCell;
@interface XBHomeViewController : UIViewController
@property (assign, nonatomic) BOOL  showMenu;

- (XBHomeCell *)currentHomeCell;

@end
