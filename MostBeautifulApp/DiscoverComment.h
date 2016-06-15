//
//  DiscoverComment.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface DiscoverComment : Model <MTLManagedObjectSerializing>
@property (assign, nonatomic) NSInteger     count;
@property (strong, nonatomic) NSString      *authorBgcolor;
@property (assign, nonatomic) BOOL          canShow;
@property (assign, nonatomic) NSInteger     supportTimes;
@property (strong, nonatomic) NSString      *createdAt;
@property (strong, nonatomic) NSString      *authorCareer;
@property (assign, nonatomic) long          appId;
@property (strong, nonatomic) NSString      *authorGender;
@property (strong, nonatomic) NSString      *updatedAt;
@property (strong, nonatomic) NSString      *content;
@property (assign, nonatomic) NSInteger     objectTimes;
@property (assign, nonatomic) NSInteger     replyCount;
@property (strong, nonatomic) NSString      *authorName;
@property (assign, nonatomic) NSInteger     authorFlowers;
@property (strong, nonatomic) NSString      *appTitle;
@property (assign, nonatomic) BOOL          isOncover;
@property (assign, nonatomic) long          authorId;
@property (strong, nonatomic) NSString      *authorAvatarUrl;
@end
