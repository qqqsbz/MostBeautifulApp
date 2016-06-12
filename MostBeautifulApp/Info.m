//
//  Info.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Info.h"

@implementation Info

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
    return @{@"upUsers":@"up_users",
             @"favUsers":@"fav_users",
             @"downUsers":@"down_users"
             };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"upUsers"] || [key isEqualToString:@"favUsers"] || [key isEqualToString:@"downUsers"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *array) {
            return [NSKeyedArchiver archivedDataWithRootObject:array];
        } reverseBlock:^id(NSData *data) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }];
    } else{
        return nil;
    }
}

@end
