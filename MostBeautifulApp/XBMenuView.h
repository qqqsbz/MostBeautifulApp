//
//  XBMenuView.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XBMenuViewType){
    XBMenuViewTypeView = 0,
    XBMenuViewTypeNavBar
};

typedef NS_ENUM(NSInteger,XBMenuViewDidSelectedType) {
    XBMenuViewDidSelectedTypeFavorite = 0,
    XBMenuViewDidSelectedTypeShare,
    XBMenuViewDidSelectedTypeDownload
};

@class XBMenuView;
@protocol XBMenuViewDelegate <NSObject>

@optional
- (void)menuView:(XBMenuView *)menuView didSelectedWithType:(XBMenuViewDidSelectedType)type atIndex:(NSInteger)index;

@end

typedef void(^complete)(BOOL finished);

@interface XBMenuView : UIView

@property (strong, nonatomic) NSDictionary  *data;

@property (weak, nonatomic) id<XBMenuViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images type:(XBMenuViewType)type;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray<UIImage *> *)images titles:(NSArray<NSString *> *)titles type:(XBMenuViewType)type;

- (void)replaceImage:(UIImage *)image atIndex:(NSInteger)index;

- (void)replaceTitle:(NSString *)title atIndex:(NSInteger)index;

- (void)showWithComplete:(complete)complete;

- (void)hideWithComplete:(complete)complete;
@end