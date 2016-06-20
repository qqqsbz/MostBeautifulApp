//
//  XBDiscoverPushTransition.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/17.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBDiscoverPushTransitionType) {
    XBDiscoverPushTransitionTypePush = 0,
    XBDiscoverPushTransitionTypePop
};
@interface XBDiscoverPushTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)transitionWithTransitionType:(XBDiscoverPushTransitionType)type;

- (instancetype)initWithTransitionType:(XBDiscoverPushTransitionType)type;

@end
