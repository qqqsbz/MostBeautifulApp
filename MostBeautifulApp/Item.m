//
//  Item.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Item.h"

@implementation Item

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
    return @{@"iconImage":@"icon_image",
             @"onSideBar":@"on_sidebar",
             @"titleConstantKey":@"title_constant_key"
             };
}

@end
