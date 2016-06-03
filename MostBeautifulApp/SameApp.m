//
//  SameApp.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "SameApp.h"
#import "Author.h"
@implementation SameApp
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
    return @{@"upTimes":@"up_times",
             @"modelId":@"id"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"author":[Author class]};
}

+ (NSValueTransformer *)authorJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Author class]];
}

@end
