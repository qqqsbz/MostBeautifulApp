//
//  Search.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Search.h"

@implementation Search
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
             @"modelId":@"id",
             @"isApp":@"is_app",
             @"minSdkVersion":@"min_sdk_version",
             @"packageName":@"package_name",
             @"subTitle":@"sub_title"
             };
}
@end
