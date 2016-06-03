//
//  HttpClient.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHttpClient.h"
#import "App.h"
#import <Mantle/Mantle.h>

@interface XBHttpClient()
@property (strong, nonatomic) NSString  *api;
@end
static NSString *kPrefix = @"#api#";
static NSString *kPagePrefix = @"#pageSize#";
static NSString *kToday = @"/apps/app/daily/?"; //每日最美
static NSString *kRecommend = @"/category/100/all/?";//限免推荐
static NSString *kArticle = @"/media/list/?type=zhuanlan";//文章专栏
static NSString *kFindApp = @"/community/recommend_apps/?";//发现应用
static NSString *kAppStore = @"https://itunes.apple.com/cn/app/zui-mei-ying-yong/id739652274?mt=8";//美我一下
static NSString *kApiInvite = @"http://zuimeia.com/article/100/?utm_medium=community_android&utm_source=niceapp";//招聘编辑
static NSString  *kSuccessPrefix = @"result";
static NSString  *kSuccessData = @"data";
static NSString  *kSuccessApps = @"apps";
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

- (void)getTodayWithPageSize:(NSInteger)pageSize Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *api = [self.api stringByReplacingOccurrencesOfString:kPrefix withString:@"/apps/app/daily/?"];
    api = [api stringByReplacingOccurrencesOfString:kPagePrefix withString:[NSString stringWithFormat:@"%d",pageSize]];
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

- (NSString *)api
{
    if (!_api) {
        _api = [NSString stringWithFormat:@"http://zuimeia.com/api%@&appVersion=2.2.4&openUDID=1bf9ccab8d121135bed763089b514aff901ffc28&systemVersion=9.1&page_size=%@&platform=1%@",kPrefix,kPagePrefix,@"&resolution=%7B750%2C%201334%7D"];
    }
    return _api;
}
@end
