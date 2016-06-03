//
//  Author.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Author : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSString  *userName;
@property (strong, nonatomic) NSString  *career;
@property (strong, nonatomic) NSString  *gender;
@property (strong, nonatomic) NSString  *bgColor;
@property (strong, nonatomic) NSString  *avatarUrl;
@property (assign, nonatomic) NSInteger identity;
@property (assign, nonatomic) NSInteger flowers;
@property (strong, nonatomic) NSString  *enname;
@end
