//
//  Range.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Range : NSObject

@property (assign, nonatomic) NSInteger  location;
@property (assign, nonatomic) NSInteger  length;

+ (instancetype)rangeWithLocation:(NSInteger)location length:(NSInteger)length;

- (instancetype)initWithLocation:(NSInteger)location length:(NSInteger)length;

@end
