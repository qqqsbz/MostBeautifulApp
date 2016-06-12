//
//  User.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"
@class Statics;
@interface User : Model
@property (strong, nonatomic) NSString  *bgColor;
@property (strong, nonatomic) NSString  *desc;
@property (assign, nonatomic) NSInteger flowers;
@property (strong, nonatomic) NSString  *gender;
@property (assign, nonatomic) NSInteger identity;
@property (strong, nonatomic) NSString  *image;
@property (assign, nonatomic) NSInteger inviteAuth;
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *nick;
@property (strong, nonatomic) NSString  *snsType;
@property (assign, nonatomic) NSInteger uid;
@property (strong, nonatomic) NSString  *weiboUid;
@property (strong, nonatomic) Statics   *statics;
@end
