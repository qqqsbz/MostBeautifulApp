//
//  HttpClient.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHttpClient.h"
#import "App.h"
#import "User.h"
#import "Comment.h"
#import "Search.h"
#import <Mantle/Mantle.h>

@interface XBHttpClient()
@property (strong, nonatomic) NSString  *api;
@end
static NSString *kPrefix = @"#api#";
static NSString *kPagePrefix = @"#pageSize#";
static NSString *kToday = @"/apps/app/daily/?"; //每日最美
static NSString *kComment = @"/apps/comment/?"; // 留言
static NSString *kSearch  = @"/search/?";//搜索
static NSString *kAppDetail = @"/apps/app/%d/?";//查询app详细信息
static NSString *kLiability = @"/category/100/all/?type=zuimei.daily";//限免推荐
static NSString *kArticle = @"/media/list/?type=zhuanlan";//文章专栏
static NSString *kFindApp = @"/community/recommend_apps/?";//发现应用
static NSString *kAppStore = @"https://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8";//美我一下
static NSString *kSinaLogin = @"http://zuimeia.com/api/user/weibo/signup/?openUDID=d41d8cd98f00b204e9800998ecf8427e2c09ef55&systemVersion=9.1&appVersion=2.3.0&resolution=%7B640,%201136%7D&platform=1";
static NSString *kSuccessPrefix = @"result";
static NSString *kSuccessData = @"data";
static NSString *kSuccessComments = @"comments";
static NSString *kSuccessApps = @"apps";
static NSString *kSuccessSearchApps = @"apps";
static NSString *kSuccessSearchArticles = @"articles";
static NSInteger kSuccessCode = 1;
@implementation XBHttpClient

+ (instancetype)shareInstance
{
    static XBHttpClient *client = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        client = [[XBHttpClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    });
    return client;
}

- (void)getTodayWithPageSize:(NSInteger)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *api = [self.api stringByReplacingOccurrencesOfString:kPrefix withString:kToday];
    api = [api stringByReplacingOccurrencesOfString:kPagePrefix withString:[NSString stringWithFormat:@"%ld",(long)pageSize]];
    DDLogCDebug(@"api:%@",api);
    [self GET:api parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:kSuccessPrefix] integerValue] == kSuccessCode) {
            NSDictionary  *data = [responseObject valueForKey:kSuccessData];
            id app = [data valueForKey:kSuccessApps];
            NSError *error = nil;
            if ([app isKindOfClass:[NSArray class]]) {
                app = [MTLJSONAdapter modelsOfClass:[App class] fromJSONArray:app error:&error];
            } else if ([app isKindOfClass:[NSDictionary class]]) {
                app = [MTLJSONAdapter modelOfClass:[App class] fromJSONDictionary:app error:&error];
            }
            
            if (!error) {
                success(app);
            } else {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getLiabilityWithPage:(NSInteger)page pageSize:(NSInteger)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *api = [self.api stringByReplacingOccurrencesOfString:kPrefix withString:kLiability];
    api = [api stringByReplacingOccurrencesOfString:kPagePrefix withString:[NSString stringWithFormat:@"%ld",(long)pageSize]];
    api = [api stringByAppendingString:[NSString stringWithFormat:@"&page=%d",page]];
    DDLogCDebug(@"api:%@",api);
    
    [self GET:api parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:kSuccessPrefix] integerValue] == kSuccessCode) {
            NSDictionary  *data = [responseObject valueForKey:kSuccessData];
            id app = [data valueForKey:kSuccessApps];
            NSError *error = nil;
            if ([app isKindOfClass:[NSArray class]]) {
                app = [MTLJSONAdapter modelsOfClass:[App class] fromJSONArray:app error:&error];
            } else if ([app isKindOfClass:[NSDictionary class]]) {
                app = [MTLJSONAdapter modelOfClass:[App class] fromJSONDictionary:app error:&error];
            }
            
            if (!error) {
                success(app);
            } else {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getCommentWithAppId:(NSInteger)appId page:(NSInteger)page pageSize:(NSInteger)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *api = [self.api stringByReplacingOccurrencesOfString:kPrefix withString:kComment];
    api = [api stringByReplacingOccurrencesOfString:kPagePrefix withString:[NSString stringWithFormat:@"%ld",(long)pageSize]];
    api = [api stringByAppendingString:[NSString stringWithFormat:@"&page=%d",page]];
    api = [api stringByAppendingString:[NSString stringWithFormat:@"&app=%d",appId]];
    DDLogCDebug(@"api:%@",api);
    [self GET:api parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:kSuccessPrefix] integerValue] == kSuccessCode) {
            NSDictionary  *data = [responseObject valueForKey:kSuccessData];
            id app = [data valueForKey:kSuccessComments];
            NSError *error = nil;
            if ([app isKindOfClass:[NSArray class]]) {
                app = [MTLJSONAdapter modelsOfClass:[Comment class] fromJSONArray:app error:&error];
            } else if ([app isKindOfClass:[NSDictionary class]]) {
                app = [MTLJSONAdapter modelOfClass:[Comment class] fromJSONDictionary:app error:&error];
            }
            
            if (!error) {
                success(app);
            } else {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)userLoginWithParamter:(NSDictionary *)paramter success:(void (^)(User *))success failure:(void (^)(NSError *))failure
{
    [self POST:kSinaLogin parameters:paramter success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:kSuccessPrefix] integerValue] == kSuccessCode) {
            
            NSDictionary  *data = [responseObject valueForKey:kSuccessData];
            NSError *error = nil;
            User *user = [MTLJSONAdapter modelOfClass:[User class] fromJSONDictionary:data error:&error];
            
            if (!error) {
                success(user);
            } else {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)searchWithParamter:(NSDictionary *)paramter success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *api = [self.api stringByReplacingOccurrencesOfString:kPrefix withString:kSearch];
    api = [api stringByReplacingOccurrencesOfString:kPagePrefix withString:@""];
    DDLogDebug(@"api:%@",api);
    [self POST:api parameters:paramter success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:kSuccessPrefix] integerValue] == kSuccessCode) {
            NSDictionary  *data = [responseObject valueForKey:kSuccessData];

            id app = [data valueForKey:kSuccessSearchArticles];
            NSArray *results = [NSArray array];
            NSError *error = nil;
            if ([app isKindOfClass:[NSArray class]]) {
                results = [MTLJSONAdapter modelsOfClass:[Search class] fromJSONArray:app error:&error];
            }
            
            if (!error) {
                success(results);
            } else {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getSearchHistoryWithAppId:(NSInteger)appId success:(void (^)(App *app))success failure:(void (^)(NSError *))failure
{
    NSString *param = [NSString stringWithFormat:kAppDetail,appId];
    NSString *api = [self.api stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@&",kPrefix] withString:param];
    api = [api stringByReplacingOccurrencesOfString:kPagePrefix withString:@"0"];
    DDLogDebug(@"api:%@",api);
    [self GET:api parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:kSuccessPrefix] integerValue] == kSuccessCode) {
            
            NSDictionary  *data = [responseObject valueForKey:kSuccessData];
            NSError *error = nil;
            App *app = [MTLJSONAdapter modelOfClass:[App class] fromJSONDictionary:data error:&error];
            
            if (!error) {
                success(app);
            } else {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)getArticleWithSuccess:(void (^)(NSArray<App *> *))success failure:(void (^)(NSError *))failure
{
    NSString *api = [self.api stringByReplacingOccurrencesOfString:kPrefix withString:kArticle];
    api = [api stringByReplacingOccurrencesOfString:kPagePrefix withString:@""];
    [self GET:api parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject valueForKey:kSuccessPrefix] integerValue] == kSuccessCode) {
            NSDictionary  *data = [responseObject valueForKey:kSuccessData];
            id app = [data valueForKey:kSuccessApps];
            NSError *error = nil;
            if ([app isKindOfClass:[NSArray class]]) {
                app = [MTLJSONAdapter modelsOfClass:[App class] fromJSONArray:app error:&error];
            } else if ([app isKindOfClass:[NSDictionary class]]) {
                app = [MTLJSONAdapter modelOfClass:[App class] fromJSONDictionary:app error:&error];
            }
            
            if (!error) {
                success(app);
            } else {
                failure(error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (NSString *)api
{
    if (!_api) {
        _api = [NSString stringWithFormat:@"http://zuimeia.com/api%@&appVersion=2.2.4&openUDID=1bf9ccab8d121135bed763089b514aff901ffc28&systemVersion=9.1&page_size=%@&platform=1%@",kPrefix,kPagePrefix,@"&resolution=%7B750%2C%201334%7D"];
    }
    return _api;
}
@end
