//
//  Range.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Range.h"

@implementation Range

+ (instancetype)rangeWithLocation:(NSInteger)location length:(NSInteger)length
{
    return [[self alloc] initWithLocation:location length:length];
}

- (instancetype)initWithLocation:(NSInteger)location length:(NSInteger)length
{
    if (self = [super init]) {
        _location = location;
        _length = length;
    }
    return self;
}

@end
