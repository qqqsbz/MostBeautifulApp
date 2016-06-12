//
//  User.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "User.h"
#import "Statics.h"
@implementation User
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
    return @{@"bgColor":@"bg_color",
             @"desc":@"description",
             @"inviteAuth":@"invite_auth",
             @"snsType":@"sns_type",
             @"weiboUid":@"weibo_uid"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"statics":[Statics class]};
}

+ (NSValueTransformer *)staticsJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Statics class]];
}
@end
