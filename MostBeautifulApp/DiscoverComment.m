//
//  DiscoverComment.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "DiscoverComment.h"

@implementation DiscoverComment

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
    return @{@"authorBgcolor":@"author_bgcolor",
             @"canShow":@"can_show",
             @"supportTimes":@"supporttimes",
             @"createdAt":@"created_at",
             @"authorCareer":@"author_career",
             @"appId":@"app_id",
             @"authorGender":@"author_gender",
             @"updatedAt":@"updated_at",
             @"modelId":@"id",
             @"objectTimes":@"objecttimes",
             @"replyCount":@"reply_count",
             @"authorName":@"author_name",
             @"authorFlowers":@"author_flowers",
             @"appTitle":@"app_title",
             @"isOncover":@"isoncover",
             @"authorId":@"author_id",
             @"authorAvatarUrl":@"author_avatar_url"
             };
}


@end
