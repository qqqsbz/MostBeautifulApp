//
//  Discover.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Discover : Model <MTLManagedObjectSerializing>
@property (assign, nonatomic) BOOL          isBetaEnd;
@property (strong, nonatomic) NSString      *appName;
@property (strong, nonatomic) NSString      *packageName;
@property (assign, nonatomic) long          pos;
@property (strong, nonatomic) NSString      *authorGender;
@property (assign, nonatomic) NSInteger     authorIdentity;
@property (assign, nonatomic) NSInteger     authorFlowers;
@property (strong, nonatomic) NSString      *size;
@property (assign, nonatomic) NSInteger     platformId;
@property (strong, nonatomic) NSString      *title;
@property (assign, nonatomic) float         minSdkVersion;
@property (strong, nonatomic) NSString      *subTitle;
@property (strong, nonatomic) NSString      *iconImage;
@property (assign, nonatomic) NSInteger     showTimes;
@property (strong, nonatomic) NSString      *desc;
@property (strong, nonatomic) NSString      *updatedAt;
@property (assign, nonatomic) NSInteger     collectTimes;
@property (strong, nonatomic) NSString      *authorName;
@property (assign, nonatomic) NSInteger     downTimes;
@property (strong, nonatomic) NSString      *authorAvatarUrl;
@property (assign, nonatomic) BOOL          isBeta;
@property (strong, nonatomic) NSString      *authorBgcolor;
@property (assign, nonatomic) NSInteger     commentTimes;
@property (strong, nonatomic) NSString      *createdAt;
@property (strong, nonatomic) NSString      *platformName;
@property (assign, nonatomic) NSInteger     upTimes;
@property (assign, nonatomic) BOOL          canShow;
@property (strong, nonatomic) NSString      *authorCareer;
@property (strong, nonatomic) NSString      *coverImage;
@property (assign, nonatomic) long          authorId;

@property (strong, nonatomic) NSArray       *sameApps;
@property (strong, nonatomic) NSArray       *downloadUrls;
@property (strong, nonatomic) NSArray       *collectUsers;
@property (strong, nonatomic) NSArray       *comments;
@property (strong, nonatomic) NSArray       *redirectDownloadUrls;
@property (strong, nonatomic) NSArray       *upUsers;
@property (strong, nonatomic) NSArray       *tags;
@property (strong, nonatomic) NSArray       *allImages;
@property (strong, nonatomic) NSArray       *downUsers;
@end
