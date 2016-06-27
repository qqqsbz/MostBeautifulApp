 //
//  XBUserDefaultsUtil.m
//  iPenYou
//
//  Created by fanly frank on 10/17/14.
//  Copyright (c) 2014 vbuy. All rights reserved.
//
static NSString *const kBeautifulUserInfo = @"BEAUTIFUL_USER_INFO";

#import "XBUserDefaultsUtil.h"

@implementation XBUserDefaultsUtil

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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [defaults setObject:data forKey:kBeautifulUserInfo];
    [defaults synchronize];
}

+ (void)clearUserInfo
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kBeautifulUserInfo];
}

@end
