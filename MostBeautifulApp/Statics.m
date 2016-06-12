//
//  Statics.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Statics.h"

@implementation Statics

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
    return @{@"appDownHistory":@"app_down_history",
             @"appFavHistory":@"app_fav_history",
             @"appUpHistory":@"app_up_history",
             @"communityDownHistory":@"community_down_history",
             @"communityFavHistory":@"community_fav_history",
             @"communityUpHistory":@"community_up_history",
             @"nincegoodsDownHistory":@"nincegoods_down_history",
             @"nincegoodsFavHistory":@"nincegoods_fav_history",
             @"nincegoodsUpHistory":@"nincegoods_up_history"
             };
}

//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *array) {
//        return [NSKeyedArchiver archivedDataWithRootObject:array];
//    } reverseBlock:^id(NSData *data) {
//        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    }];
//}
@end
