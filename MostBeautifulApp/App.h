//
//  App.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"
@class Info;
@class Comments;
@interface App : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSString  *thankTo;
@property (strong, nonatomic) NSString  *coverCommentAuthorAvatarUrl;
@property (strong, nonatomic) NSString  *videoUrl;
@property (strong, nonatomic) NSString  *coverCommentContent;
@property (strong, nonatomic) NSArray   *sameApps;
@property (strong, nonatomic) NSArray   *upUsers;
@property (strong, nonatomic) NSString  *authorGender;
@property (strong, nonatomic) NSString  *qrcodeImage;
@property (strong, nonatomic) NSString  *createTime;
@property (strong, nonatomic) Comments  *comments;
@property (strong, nonatomic) NSString  *coverCommentArticle;
@property (strong, nonatomic) NSString  *digest;
@property (strong, nonatomic) NSString  *size;
@property (strong, nonatomic) NSString  *coverCommentId;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *coverCommentAuthorBgcolor;
@property (assign, nonatomic) float     minSdkVersion;
@property (strong, nonatomic) NSString  *subTitle;
@property (strong, nonatomic) NSString  *downloadUrl;
@property (strong, nonatomic) NSString  *iconImage;
@property (strong, nonatomic) NSString  *content;
@property (strong, nonatomic) NSString  *version;
@property (strong, nonatomic) NSString  *recommendLevel;
@property (strong, nonatomic) NSString  *coverCommentAuthorGender;
@property (strong, nonatomic) NSString  *coverCommentIsOnCover;
@property (strong, nonatomic) NSString  *updateTime;
@property (strong, nonatomic) NSString  *authorUsername;
@property (strong, nonatomic) NSString  *coverCommentAuthorName;
@property (strong, nonatomic) NSString  *coverCommentAuthorCareer;
@property (strong, nonatomic) NSString  *coverCommentUpdatedAt;
@property (assign, nonatomic) float     price;
@property (assign, nonatomic) BOOL      videoIsPortrait;
@property (strong, nonatomic) NSString  *recommandedDate;
@property (strong, nonatomic) NSString  *coverCommentAuthorId;
@property (strong, nonatomic) NSString  *recommandedBackgroundColor;
@property (strong, nonatomic) NSString  *priceFormat;
@property (strong, nonatomic) NSString  *authorAvatarUrl;
@property (strong, nonatomic) NSString  *tags;
@property (strong, nonatomic) Info      *info;
@property (strong, nonatomic) NSString  *authorBgcolor;
@property (strong, nonatomic) NSArray   *otherDownloadUrl;
@property (strong, nonatomic) NSString  *coverCommentCreatedAt;
@property (strong, nonatomic) NSString  *publishDate;
@property (strong, nonatomic) NSString  *authorCareer;
@property (strong, nonatomic) NSString  *coverImage;
@property (strong, nonatomic) NSString  *videoShareUrl;
@property (assign, nonatomic) NSInteger authorId;
@property (strong, nonatomic) NSString  *packageName;


- (id)deriveModelWithTemplateModelClass:(Class)modelClass;

@end
