//
//  XMLParserUtils.h
//  XMLParserDemo
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Complete)(NSArray *datas);

@class XBXMLParserContent;
@interface XBXMLParserUtils : NSObject

+ (instancetype)parserWithContent:(NSString *)content complete:(Complete)block;

- (instancetype)initParserWithContent:(NSString *)content complete:(Complete)block;

@end
