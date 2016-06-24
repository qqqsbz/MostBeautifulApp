//
//  TTTAttributedLabel+AnalysisHTMLTag.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "TTTAttributedLabel+AnalysisHTMLTag.h"
#import "RegexKitLite.h"

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

@implementation TTTAttributedLabel (AnalysisHTMLTag)

//** 解析html标签 */
- (void)analysisHTMLTagWithPrefixTag:(NSString *)prefixTag suffixTag:(NSString *)suffixTag analysisingBlock:(AnalysisHTMLBlock)analysisingBlock complete:(Complete)complete
{
    if ([prefixTag isEqualToString:suffixTag]) {
        DDLogDebug(@"html tag format error!");
        return;
    }
    
    NSInteger count = [self.text componentsMatchedByRegex:prefixTag].count;
    __block NSInteger index = 0;
    NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:count];
    
    //解析html标签
    [self.text enumerateStringsMatchedByRegex:[NSString stringWithFormat:@"%@.*?%@",prefixTag,suffixTag] usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        [ranges addObject:[Range rangeWithLocation:(*capturedRanges).location length:(*capturedRanges).length]];
        
        index++;
        
        if (count == index) {
            
            self.text = [self.text stringByReplacingOccurrencesOfString:prefixTag withString:@""];
            self.text = [self.text stringByReplacingOccurrencesOfString:suffixTag withString:@""];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
            
            for (NSInteger i = 0 ; i < count; i++) {
                
                Range *mrange = ranges[i];
                
                NSRange range;
                
                NSInteger labelLength = prefixTag.length + suffixTag.length;
                
                if (i == 0) {
                
                    range = NSMakeRange(mrange.location, mrange.length - labelLength);
                
                } else {
                    
                    range = NSMakeRange(mrange.location - labelLength, mrange.length - labelLength);
                
                }
                
                if (analysisingBlock) {
                    analysisingBlock(attributedString,range);
                }
                
            }
            
            if (complete) {
                complete(attributedString);
            }
            
            self.attributedText = attributedString;
            
        }
    }];
}

@end
