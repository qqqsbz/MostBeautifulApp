//
//  XBPushTransition.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/30.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBPushTransitionType) {
    XBPushTransitionTypePush = 0,
    XBPushTransitionTypePop
};
@interface XBPushTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBPushTransitionType)type;

- (instancetype)initWithTransitionType:(XBPushTransitionType)type;

@end
