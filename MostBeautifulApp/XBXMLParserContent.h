//
//  ParserContent.h
//  XMLParserDemo
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,XBParserContentType) {
    XBParserContentTypeText = 0,
    XBParserContentTypeLink,
    XBParserContentTypeImage,
    XBParserContentTypeTitle
};

@interface XBXMLParserContent : NSObject
@property (strong, nonatomic) NSString  *content;
@property (assign, nonatomic) XBParserContentType  contentType;
@end
