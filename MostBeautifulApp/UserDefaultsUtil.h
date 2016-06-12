//
//  UserDefaultsUtil.h
//  iPenYou
//
//  Created by fanly frank on 10/17/14.
//  Copyright (c) 2014 vbuy. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UserDefaultsUtil : NSObject

+ (id)userInfo;

+ (void)updateUserInfo:(id)user;

+ (void)clearUserInfo;

@end
