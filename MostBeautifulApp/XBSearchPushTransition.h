//
//  XBSearchPushTransition.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBSearchPushTransitionType) {
    XBSearchPushTransitionTypePush = 0,
    XBSearchPushTransitionTypePop
};
@interface XBSearchPushTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBSearchPushTransitionType)type;

- (instancetype)initWithTransitionType:(XBSearchPushTransitionType)type;



@end
