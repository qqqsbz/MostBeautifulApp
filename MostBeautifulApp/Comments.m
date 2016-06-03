//
//  Comments.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Comments.h"
#import "Comment.h"
@implementation Comments
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
    return @{@"hasNext":@"has_next",
             @"modelId":@"id"
             };
}


+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"data":[Comment class]};
}

+ (NSValueTransformer *)dataJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Comment class]];
}

@end
