//
//  XWInteractiveTransition.h
//  XWTrasitionPractice
//
//  Created by YouLoft_MacMini on 15/11/24.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureConifg)();

typedef NS_ENUM(NSUInteger, XBInteractiveTransitionGestureDirection) {//手势的方向
    XBInteractiveTransitionGestureDirectionLeft = 0,
    XBInteractiveTransitionGestureDirectionRight,
    XBInteractiveTransitionGestureDirectionUp,
    XBInteractiveTransitionGestureDirectionDown
};

typedef NS_ENUM(NSUInteger, XBInteractiveTransitionType) {//手势控制哪种转场
    XBInteractiveTransitionTypePresent = 0,
    XBInteractiveTransitionTypeDismiss,
    XBInteractiveTransitionTypePush,
    XBInteractiveTransitionTypePop,
};

@interface XBInteractiveTransition : UIPercentDrivenInteractiveTransition
/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;

//初始化方法

+ (instancetype)interactiveTransitionWithTransitionType:(XBInteractiveTransitionType)type GestureDirection:(XBInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(XBInteractiveTransitionType)type GestureDirection:(XBInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;
@end
