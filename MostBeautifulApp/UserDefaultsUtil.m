 //
//  UserDefaultsUtil.m
//  iPenYou
//
//  Created by fanly frank on 10/17/14.
//  Copyright (c) 2014 vbuy. All rights reserved.
//
static NSString *const kBeautifulUserInfo = @"BEAUTIFUL_USER_INFO";

#import "UserDefaultsUtil.h"

@implementation UserDefaultsUtil

//user info
+ (id)userInfo
{
    id data = [[NSUserDefaults standardUserDefaults] objectForKey:kBeautifulUserInfo];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

+ (void)updateUserInfo:(id)user
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kBeautifulUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBeautifulUserInfo];
}

@end
