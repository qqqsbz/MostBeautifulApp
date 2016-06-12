//
//  App.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "App.h"
#import "SameApp.h"
#import "Info.h"
#import "Comments.h"
@implementation App
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
             @"upUsers":[SameApp class],
             @"info":[Info class],
             @"comments":[Comments class]
            };
}

+ (NSValueTransformer *)sameAppsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SameApp class]];
}

+ (NSValueTransformer *)upUsersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SameApp class]];
}

+ (NSValueTransformer *)infoJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Info class]];
}

//+ (NSValueTransformer *)commentsJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Comments class]];
//}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"thankTo":@"thankto",
             @"coverCommentAuthorAvatarUrl":@"cover_comment_author_avatar_url",
             @"videoUrl":@"video_url",
             @"coverCommentContent":@"cover_comment_content",
             @"sameApps":@"same_apps",
             @"upUsers":@"up_users",
             @"authorGender":@"author_gender",
             @"qrcodeImage":@"qrcode_image",
             @"createTime":@"create_time",
             @"modelId":@"id",
             @"coverCommentArticle":@"cover_comment_article",
             @"coverCommentId":@"cover_comment_id",
             @"coverCommentAuthorBgcolor":@"cover_comment_author_bgcolor",
             @"minSdkVersion":@"min_sdk_version",
             @"subTitle":@"sub_title",
             @"downloadUrl":@"download_url",
             @"iconImage":@"icon_image",
             @"recommendLevel":@"recommend_level",
             @"coverCommentAuthorGender":@"cover_comment_author_gender",
             @"coverCommentIsOnCover":@"cover_comment_is_on_cover",
             @"updateTime":@"update_time",
             @"authorUsername":@"author_username",
             @"coverCommentAuthorName":@"cover_comment_author_name",
             @"coverCommentAuthorCareer":@"cover_comment_author_career",
             @"coverCommentUpdatedAt":@"cover_comment_updated_at",
             @"videoIsPortrait":@"video_is_portrait",
             @"recommandedDate":@"recommanded_date",
             @"coverCommentAuthorId":@"cover_comment_author_id",
             @"recommandedBackgroundColor":@"recommanded_background_color",
             @"priceFormat":@"price_format",
             @"authorAvatarUrl":@"author_avatar_url",
             @"authorBgcolor":@"author_bgcolor",
             @"otherDownloadUrl":@"other_download_url",
             @"coverCommentCreatedAt":@"cover_comment_created_at",
             @"publishDate":@"publish_date",
             @"authorCareer":@"author_career",
             @"coverImage":@"cover_image",
             @"videoShareUrl":@"video_share_url",
             @"authorId":@"author_id",
             @"packageName":@"package_name"
            };
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key{
    if ([key isEqualToString:@"otherDownloadUrl"]) {
        return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSArray *array) {
            return [NSKeyedArchiver archivedDataWithRootObject:array];
        } reverseBlock:^id(NSData *data) {
            return [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }];
    } else{
        return nil;
    }
}

- (id)deriveModelWithTemplateModelClass:(Class)modelClass
{
    NSError *error = nil;
    NSDictionary *json = [MTLJSONAdapter JSONDictionaryFromModel:self];
    id model = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:json error:&error];
    if (error) {
        [[NSException exceptionWithName:NSInvalidArgumentException
                                 reason:[NSString stringWithFormat:@"Could not derive model for: %@", modelClass]
                               userInfo:error.userInfo] raise];
    }
    return  model;
}
@end
