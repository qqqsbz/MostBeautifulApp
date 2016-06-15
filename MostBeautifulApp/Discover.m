//
//  Discover.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Discover.h"
#import "SameApp.h"
#import "DownloadUrl.h"
#import "Author.h"
#import "DiscoverComment.h"

@implementation Discover

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

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"sameApps":[SameApp class],
             @"upUsers":[Author class],
             @"downloadUrls":[DownloadUrl class],
             @"redirectDownloadUrls":[DownloadUrl class],
             @"downUsers":[Author class],
             @"comments":[DiscoverComment class]
             };
}

+ (NSValueTransformer *)sameAppsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SameApp class]];
}

+ (NSValueTransformer *)upUsersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Author class]];
}

+ (NSValueTransformer *)downloadUrlsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DownloadUrl class]];
}

+ (NSValueTransformer *)redirectDownloadUrlsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DownloadUrl class]];
}

+ (NSValueTransformer *)downUsersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Author class]];
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[DiscoverComment class]];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"isBetaEnd":@"is_beta_end",
             @"appName":@"app_name",
             @"packageName":@"package_name",
             @"sameApps":@"same_apps",
             @"upUsers":@"up_users",
             @"authorGender":@"author_gender",
             @"authorIdentity":@"author_identity",
             @"authorFlowers":@"author_flowers",
             @"modelId":@"id",
             @"downloadUrls":@"download_urls",
             @"collectUsers":@"collect_users",
             @"minSdkVersion":@"min_sdk_version",
             @"subTitle":@"sub_title",
             @"iconImage":@"icon_image",
             @"showTimes":@"show_times",
             @"redirectDownloadUrls":@"redirect_download_urls",
             @"desc":@"description",
             @"updatedAt":@"updated_at",
             @"collectTimes":@"collect_times",
             @"authorName":@"author_name",
             @"downTimes":@"down_times",
             @"authorAvatarUrl":@"author_avatar_url",
             @"isBeta":@"is_beta",
             @"authorBgcolor":@"author_bgcolor",
             @"allImages":@"all_images",
             @"commentTimes":@"comment_times",
             @"createdAt":@"created_at",
             @"platformName":@"platform_name",
             @"upTimes":@"up_times",
             @"canShow":@"can_show",
             @"authorCareer":@"author_career",
             @"coverImage":@"cover_image",
             @"authorId":@"author_id",
             @"downUsers":@"down_users"
             };
}

//+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
//    if ([key isEqualToString:@"collectUsers"] || [key isEqualToString:@"tags"] || [key isEqualToString:@"allImages"]) {
//        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *array) {
//            return [NSKeyedArchiver archivedDataWithRootObject:array];
//        } reverseBlock:^id(NSData *data) {
//            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        }];
//    } else{
//        return nil;
//    }
//}


@end
