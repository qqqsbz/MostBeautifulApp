//
//  SameApp.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"
@class Author;
@interface SameApp : Model <MTLManagedObjectSerializing>
@property (assign, nonatomic) NSInteger upTimes;
@property (strong, nonatomic) NSString  *type;
@property (strong, nonatomic) NSString  *digest;
@property (strong, nonatomic) Author    *author;
@end
