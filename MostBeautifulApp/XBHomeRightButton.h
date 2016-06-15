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

@property (strong, nonatomic) NSString  *currentDateString;

- (instancetype)initWithFrame:(CGRect)frame homeBlock:(dispatch_block_t)block type:(XBHomeRightType)type;

@end
