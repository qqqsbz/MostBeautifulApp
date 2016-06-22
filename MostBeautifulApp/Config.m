//
//  Config.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Config.h"
#import "SideMenu.h"
#import "AboutConfig.h"
@implementation Config
+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}

+ (NSSet *)propertyKeysForManagedObjectUniquing
{
    return [NSSet setWithObject:@"modelId"];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"sideMenu":@"side_menu",
             @"aboutConfig":@"about_config",
             @"modelId":@"id"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"sideMenu":[SideMenu class],
             @"aboutConfig":[AboutConfig class]
             };
}

+ (NSValueTransformer *)sideMenuJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[SideMenu class]];
}

+ (NSValueTransformer *)aboutConfigJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[AboutConfig class]];
}
@end
