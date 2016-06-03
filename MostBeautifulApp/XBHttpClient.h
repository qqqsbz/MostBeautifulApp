//
//  HttpClient.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//


#import <AFNetworking/AFHTTPSessionManager.h>

@interface XBHttpClient : AFHTTPSessionManager
+ (instancetype)shareInstance;

- (void)getTodayWithPageSize:(NSInteger)pageSize
                     Success:(void (^)(NSArray *datas))success
                     failure:(void (^)(NSError *error))failure;

@end
