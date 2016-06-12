//
//  XBRecruitNavigationBar.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBRecruitNavigationBar : UIView

@property (strong, nonatomic) NSString  *title;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title right:(NSString *)right complete:(dispatch_block_t)complete;

@end
