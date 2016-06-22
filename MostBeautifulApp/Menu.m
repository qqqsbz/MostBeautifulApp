//
//  Menu.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Menu.h"

@implementation Menu
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"iconUrl":@"icon_url",
             @"canShow":@"can_show",
             @"verboseName":@"verbose_name",
             @"defaultOpen":@"default_open"
             };
}

@end
