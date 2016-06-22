//
//  XMLParserUtils.m
//  XMLParserDemo
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBXMLParserUtils.h"
#import "XBXMLParserContent.h"
@interface XBXMLParserUtils() <NSXMLParserDelegate>
@property (strong, nonatomic) NSXMLParser         *parser;
@property (copy  , nonatomic) Complete            complete;
@property (strong, nonatomic) NSString            *currentElementName;
@property (strong, nonatomic) NSString            *currentValue;
@property (strong, nonatomic) XBXMLParserContent  *parserContent;
@property (strong, nonatomic) NSMutableArray      *parserContents;
@end
@implementation XBXMLParserUtils

+ (instancetype)parserWithContent:(NSString *)content complete:(Complete)block
{
    return [[self alloc] initParserWithContent:content complete:block];
}

- (instancetype)initParserWithContent:(NSString *)content complete:(Complete)block
{
    if (self = [super init]) {
        self.currentValue = @"";
        self.currentElementName = @"";
        content = [NSString stringWithFormat:@"<content>%@</content>",content];
        content = [content stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"-"];
        content = [content stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];
        content = [content stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
        content = [content stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
        content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        content = [content stringByReplacingOccurrencesOfString:@"&lsquo;" withString:@"'"];
        content = [content stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"'"];
        content = [content stringByReplacingOccurrencesOfString:@"&middot;" withString:@"."];
        content = [content stringByReplacingOccurrencesOfString:@"&yen;" withString:@"¥"];
        content = [content stringByReplacingOccurrencesOfString:@"&rarr;" withString:@"->"];
        
        self.complete = block;
        self.parserContents = [NSMutableArray array];

        self.parser = [[NSXMLParser alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        self.parser.delegate = self;
        [self.parser parse];
    }
    
    return self;
}

#pragma mark -- XMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    self.currentElementName = elementName;
    if ([self.currentElementName isEqualToString:@"img"]) {
        self.parserContent = [XBXMLParserContent new];
        self.parserContent.content = [attributeDict valueForKey:@"src"];
        self.parserContent.contentType = XBParserContentTypeImage;
        self.currentValue = self.parserContent.content;
    } else if ([self.currentElementName isEqualToString:@"a"]) {
        //防止a标签给嵌套到其他标签里面而引起的标签解析错误 如: <p> <a href="xxxx"/> </p>
        [self parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
        self.parserContent = [XBXMLParserContent new];
        self.parserContent.content = [attributeDict valueForKey:@"href"];
        self.parserContent.contentType = XBParserContentTypeLink;
        self.currentValue = self.parserContent.content;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([self.currentElementName isEqualToString:@"p"]) {
        self.currentValue = [self.currentValue stringByAppendingString:string];
        self.parserContent = [XBXMLParserContent new];
        self.parserContent.content = self.currentValue;
        self.parserContent.contentType = XBParserContentTypeText;
    } else if ([self.currentElementName isEqualToString:@"h2"]) {
        self.parserContent = [XBXMLParserContent new];
        self.parserContent.content = string;
        self.parserContent.contentType = XBParserContentTypeTitle;
        self.currentValue = string;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName
{
    if (!self.currentElementName) return;
    if (!self.parserContent || self.currentValue.length <= 0) return;
    [self.parserContents addObject:self.parserContent];
    
    self.currentElementName = @"";
    self.parserContent = nil;
    self.currentValue  = @"";
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    DDLogDebug(@"parseError:%@",parseError);
    self.complete(self.parserContents);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.complete(self.parserContents);
}


@end
