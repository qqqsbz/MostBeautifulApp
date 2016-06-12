//
//  AppFavorite.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "AppFavorite.h"

@implementation AppFavorite

+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (instancetype)favoriteAppFromApp:(App *)app
{
    NSManagedObjectContext *moc = [Application sharedManagedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@ AND %K == %d", @"modelId",app.modelId, @"type",XBAppTypeFavorite];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self managedObjectEntityName] inManagedObjectContext:moc];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.fetchLimit = 1;
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSManagedObject *managedObject = [[moc executeFetchRequest:fetchRequest error:&error] firstObject];
    AppFavorite *local = [MTLManagedObjectAdapter modelOfClass:[self class] fromManagedObject:managedObject error:&error];
    AppFavorite *model = [self changeFavoriteAppFromApp:app];
    model.isFavorite = local.isFavorite;
    return model;
}

- (BOOL)toggleFavoriteWithOutError:(NSError **)error
{
    self.isFavorite = !self.isFavorite;
    self.updateAt = [NSDate date];
    self.type = XBAppTypeFavorite;
    
    NSManagedObject *managedObject = [MTLManagedObjectAdapter managedObjectFromModel:self insertingIntoContext:[Application sharedManagedObjectContext] error:error];
    if (managedObject) {
        [Application saveSharedManagedObjectContext];
        return true;
    }
    
    self.isFavorite = !self.isFavorite;
    return NO;
}

+ (AppFavorite *)changeFavoriteAppFromApp:(App *)app
{
    AppFavorite *appFavorite = [[AppFavorite alloc] init];
    appFavorite.modelId = app.modelId;
    appFavorite.thankTo = app.thankTo;
    appFavorite.coverCommentAuthorAvatarUrl = app.coverCommentAuthorAvatarUrl;
    appFavorite.videoUrl = app.videoUrl;
    appFavorite.coverCommentContent = app.coverCommentContent;
    appFavorite.sameApps = app.sameApps;
    appFavorite.upUsers = app.upUsers;
    appFavorite.authorGender = app.authorGender;
    appFavorite.qrcodeImage = app.qrcodeImage;
    appFavorite.createTime = app.createTime;
//    appFavorite.comments = app.comments;
    appFavorite.coverCommentArticle = app.coverCommentArticle;
    appFavorite.digest = app.digest;
    appFavorite.size = app.size;
    appFavorite.coverCommentId = app.coverCommentId;
    appFavorite.title = app.title;
    appFavorite.coverCommentAuthorBgcolor = app.coverCommentAuthorBgcolor;
    appFavorite.minSdkVersion = app.minSdkVersion;
    appFavorite.subTitle = app.subTitle;
    appFavorite.downloadUrl = app.downloadUrl;
    appFavorite.iconImage = app.iconImage;
    appFavorite.content = app.content;
    appFavorite.version = app.version;
    appFavorite.recommendLevel = app.recommendLevel;
    appFavorite.coverCommentAuthorGender = app.coverCommentAuthorGender;
    appFavorite.coverCommentIsOnCover = app.coverCommentIsOnCover;
    appFavorite.updateTime = app.updateTime;
    appFavorite.authorUsername = app.authorUsername;
    appFavorite.coverCommentAuthorName = app.coverCommentAuthorName;
    appFavorite.coverCommentAuthorCareer = app.coverCommentAuthorCareer;
    appFavorite.coverCommentUpdatedAt = app.coverCommentUpdatedAt;
    appFavorite.price = app.price;
    appFavorite.videoIsPortrait = app.videoIsPortrait;
    appFavorite.recommandedDate = app.recommandedDate;
    appFavorite.coverCommentAuthorId = app.coverCommentAuthorId;
    appFavorite.recommandedBackgroundColor = app.recommandedBackgroundColor;
    appFavorite.priceFormat = app.priceFormat;
    appFavorite.authorAvatarUrl = app.authorAvatarUrl;
    appFavorite.tags = app.tags;
    appFavorite.info = app.info;
    appFavorite.authorBgcolor= app.authorBgcolor;
    appFavorite.otherDownloadUrl = app.otherDownloadUrl;
    appFavorite.coverCommentCreatedAt = app.coverCommentCreatedAt;
    appFavorite.publishDate = app.publishDate;
    appFavorite.authorCareer = app.authorCareer;
    appFavorite.coverImage = app.coverImage;
    appFavorite.videoShareUrl = app.videoShareUrl;
    appFavorite.authorId = app.authorId;
    appFavorite.packageName = app.packageName;
    appFavorite.isFavorite = NO;
    
    return appFavorite;
}


@end
