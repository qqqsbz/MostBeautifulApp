//
//  UserDefaultsUtil.h
//  iPenYou
//
//  Created by fanly frank on 10/17/14.
//  Copyright (c) 2014 vbuy. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface XBUserDefaultsUtil : NSObject


/**
 从本地获取用户信息

 @return 用户信息
 */
+ (id)userInfo;


/**
 更新用户信息

 @param user 用户信息
 */
+ (void)updateUserInfo:(id)user;


/**
 删除用户信息
 */
+ (void)clearUserInfo;

@end
