//
//  TTTAttributedLabel+AnalysisHTMLTag.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#define kLineSpacing 3.f

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface Range : NSObject

@property (assign, nonatomic) NSInteger  location;
@property (assign, nonatomic) NSInteger  length;

+ (instancetype)rangeWithLocation:(NSInteger)location length:(NSInteger)length;

- (instancetype)initWithLocation:(NSInteger)location length:(NSInteger)length;

@end

typedef void(^AnalysisHTMLBlock)(NSMutableAttributedString *attributedString , NSRange range);
typedef void(^Complete)(NSMutableAttributedString *attributedString);

@interface TTTAttributedLabel (AnalysisHTMLTag)


- (void)analysisHTMLTagWithPrefixTag:(NSString *)prefixTag suffixTag:(NSString *)suffixTag analysisingBlock:(AnalysisHTMLBlock)analysisingBlock complete:(Complete)complete;

- (void)analysisHTMLLinkWithText:(NSString *)text;

@end
