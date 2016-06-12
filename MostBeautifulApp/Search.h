//
//  Search.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Search : Model
@property (strong, nonatomic) NSString  *iconUrl;
@property (assign, nonatomic) NSInteger isApp;
@property (strong, nonatomic) NSString  *minSdkVersion;
@property (strong, nonatomic) NSString  *packageName;
@property (strong, nonatomic) NSString  *subTitle;
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *type;
@end
