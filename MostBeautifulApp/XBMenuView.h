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


@interface MenuModel : NSObject

@property (strong, nonatomic) NSString  *title;

@property (strong, nonatomic) UIImage   *image;

@property (assign, nonatomic) XBMenuViewDidSelectedType  type;

+ (instancetype)menuModelWithTitle:(NSString *)title image:(UIImage *)image type:(XBMenuViewDidSelectedType)type;

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(XBMenuViewDidSelectedType)type;

@end


@class XBMenuView;
@protocol XBMenuViewDelegate <NSObject>

@optional
- (void)menuView:(XBMenuView *)menuView didSelectedWithType:(XBMenuViewDidSelectedType)type atIndex:(NSInteger)index;

@end

typedef void(^complete)(BOOL finished);

@interface XBMenuView : UIView

@property (strong, nonatomic) NSArray<MenuModel *>  *menuModels;

@property (weak, nonatomic) id<XBMenuViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame menuModels:(NSArray<MenuModel *> *)menuModels type:(XBMenuViewType)type;

/** 根据下标替换图片 */
- (void)replaceImage:(UIImage *)image atIndex:(NSInteger)index;

/** 根据下标替换文字 */
- (void)replaceTitle:(NSString *)title atIndex:(NSInteger)index;

/** 显示  */
- (void)showWithComplete:(complete)complete;

/** 隐藏 */
- (void)hideWithComplete:(complete)complete;

@end
