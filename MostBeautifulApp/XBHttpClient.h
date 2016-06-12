//
//  HttpClient.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//


#import <AFNetworking/AFHTTPSessionManager.h>
@class User;
@class App;
@interface XBHttpClient : AFHTTPSessionManager
+ (instancetype)shareInstance;

//每日最美
- (void)getTodayWithPageSize:(NSInteger)pageSize
                     success:(void (^)(NSArray *datas))success
                     failure:(void (^)(NSError *error))failure;

//限免
- (void)getLiabilityWithPage:(NSInteger)page
                    pageSize:(NSInteger)pageSize
                     success:(void (^)(NSArray *datas))success
                     failure:(void (^)(NSError *error))failure;

//获取评论
- (void)getCommentWithAppId:(NSInteger)appId
                       page:(NSInteger)page
                   pageSize:(NSInteger)pageSize
                    success:(void (^)(NSArray *datas))success
                    failure:(void (^)(NSError *error))failure;
//用户登录
- (void)userLoginWithParamter:(NSDictionary *)paramter
                      success:(void (^)(User *user))success
                      failure:(void (^)(NSError *error))failure;
//搜索
- (void)searchWithParamter:(NSDictionary *)paramter
                   success:(void (^)(NSArray *datas))success
                   failure:(void (^)(NSError *error))failure;

//获取app的详细信息
- (void)getSearchHistoryWithAppId:(NSInteger)appId
                      success:(void (^)(App *app))success
                      failure:(void (^)(NSError *error))failure;

//获取文章专栏
- (void)getArticleWithSuccess:(void (^)(NSArray<App *> *apps))success
                      failure:(void (^)(NSError *error))failure;

@end
