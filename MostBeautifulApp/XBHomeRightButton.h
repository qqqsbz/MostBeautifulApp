//
//  HomeRightButton.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/25.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,XBHomeRightType) {
    XBHomeRightTypeDaily = 0,
    XBHomeRightTypeLiability,
    XBHomeRightTypeFavorite,
    XBHomeRightTypeArticle
};
@interface XBHomeRightButton : UIView

/** 设置当前日期 */
@property (strong, nonatomic) NSString  *currentDateString;
/** 显示返回首页的按钮 */
@property (assign, nonatomic) BOOL      showHome;

- (instancetype)initWithFrame:(CGRect)frame homeBlock:(dispatch_block_t)block type:(XBHomeRightType)type;

@end
