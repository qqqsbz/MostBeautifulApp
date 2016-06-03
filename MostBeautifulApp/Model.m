//
//  Model.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@implementation Model
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"modelId": @"id"};
}

- (void)setModelId:(NSString *)modelId
{
    if ([modelId isKindOfClass:[NSString class]]) {
        _modelId = [modelId copy];
    } else {
        _modelId = [modelId description];
    }
}
@end
