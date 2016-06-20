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
@class Discover;
@class Info;
@interface XBHttpClient : AFHTTPSessionManager
+ (instancetype)shareInstance;

//每日最美
- (void)getTodayWithPage:(NSInteger)page
                PageSize:(NSInteger)pageSize
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
//发表评论
- (void)postCommentWithAppId:(NSInteger)appId
                      params:(NSDictionary *)params
                     success:(void (^)(BOOL result))success
                     failure:(void (^)(NSError *error))failure;
//发现---发表评论
- (void)postDiscoverCommentWithParams:(NSDictionary *)params
                              success:(void (^)(BOOL result))success
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

//获取最热分享
- (void)getHotDiscoverWithPage:(NSInteger)page
                      pageSize:(NSInteger)pageSize
                       success:(void (^)(NSArray *datas))success
                       failure:(void (^)(NSError *error))failure;

//获取最新分享
- (void)getNovelDiscoverWithPos:(NSInteger)pos
                       pageSize:(NSInteger)pageSize
                        success:(void (^)(NSArray *datas))success
                        failure:(void (^)(NSError *error))failure;

//获取分享评论
- (void)getCommentWithDiscoverId:(NSInteger)appId
                       commentId:(NSInteger)commentId
                   pageSize:(NSInteger)pageSize
                    success:(void (^)(NSArray *datas))success
                    failure:(void (^)(NSError *error))failure;

//美一下
- (void)upWithAppId:(NSInteger)appId
             params:(NSDictionary *)params
            success:(void (^)(Info *info))success
            failure:(void (^)(NSError *error))failure;

//一般般
- (void)downWithAppId:(NSInteger)appId
               params:(NSDictionary *)params
              success:(void (^)(Info *info))success
              failure:(void (^)(NSError *error))failure;

//发现 美一下
- (void)discoverUpWithParams:(NSDictionary *)params
                     success:(void (^)(NSArray *authors))success
                     failure:(void (^)(NSError *error))failure;

//发现 一般般
- (void)discoverDownWithParams:(NSDictionary *)params
                       success:(void (^)(NSArray *authors))success
                       failure:(void (^)(NSError *error))failure;


@end
