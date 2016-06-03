//
//  Comment.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Comment : Model <MTLManagedObjectSerializing>
@property (assign, nonatomic) BOOL      isOnCover;
@property (strong, nonatomic) NSString  *authorBgcolor;
@property (strong, nonatomic) NSString  *createdAt;
@property (strong, nonatomic) NSString  *updatedAt;
@property (strong, nonatomic) NSString  *authorGender;
@property (strong, nonatomic) NSString  *content;
@property (strong, nonatomic) NSString  *authorName;
@property (strong, nonatomic) NSString  *authorCareer;
@property (assign, nonatomic) NSInteger article;
@property (assign, nonatomic) NSInteger authorId;
@property (strong, nonatomic) NSString  *authorAvatarUrl;
@end
