//
//  Info.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Info.h"
#import "Author.h"
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
             @"downUsers":@"down_users",
             @"upUsersDetail":@"up_users_detail"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{
             @"upUsersDetail":[Author class]
            };
}

+ (NSValueTransformer *)upUsersDetailJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Author class]];
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
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

#pragma mark -- unarchive
- (NSArray *)unarchiveObjectWithDataFromUpUsers
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)self.upUsers];
}

- (NSArray *)unarchiveObjectWithDataFromDownUsers
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)self.downUsers];
}

- (NSArray *)unarchiveObjectWithDataFromFavUsers
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)self.favUsers];
}


@end
