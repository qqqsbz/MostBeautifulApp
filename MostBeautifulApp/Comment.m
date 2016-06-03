//
//  Comment.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Comment.h"

@implementation Comment
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
    return @{@"isOnCover":@"is_on_cover",
             @"authorBgcolor":@"author_bgcolor",
             @"createdAt":@"created_at",
             @"updatedAt":@"updated_at",
             @"authorGender":@"author_gender",
             @"authorName":@"author_name",
             @"authorCareer":@"author_career",
             @"authorId":@"author_id",
             @"authorAvatarUrl":@"author_avatar_url",
             @"modelId":@"id"
            };
}

@end

