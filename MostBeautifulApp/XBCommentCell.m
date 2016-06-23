//
//  XBCommentCell.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/2.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kLineSpacing 3.f

#import "XBCommentCell.h"
#import "UIImage+Util.h"
#import "Comment.h"
#import "RegexKitLite.h"
#import "Range.h"
#import "TTTAttributedLabel.h"
@implementation XBCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentFont = [UIFont systemFontOfSize:13.f];
    
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius  = CGRectGetWidth(self.avatorImageView.frame) / 2.f;
    
    self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"#CECFD1"].CGColor;
    self.avatorImageView.layer.borderWidth = 2.f;
    
    UIImage *image = [UIImage resizeImageWithImageName:@"detail_comment_bg"];
    self.bubbleImageView.image = image;
    
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
    self.signLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
    self.contentLabel.font = self.contentFont;
    
    self.contentLabel.numberOfLines = 0.;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    self.nameLabel.text = comment.authorName;
    self.signLabel.text = comment.authorCareer;
    self.timeLabel.text = [comment.createdAt substringFromIndex:2];
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:comment.authorAvatarUrl]];
    
    __block NSString *content = [comment.content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    content = [content stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    self.contentLabel.text = content;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:kLineSpacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    
    self.contentLabel.attributedText = attributedString;

    [self analysisHtmlLabelWithPrefixLabel:@"<strong>" suffixLabel:@"</strong>"];
}

//** 解析html标签 */
- (void)analysisHtmlLabelWithPrefixLabel:(NSString *)prefixLabel suffixLabel:(NSString *)suffixLabel
{
    NSInteger count = [self.comment.content componentsMatchedByRegex:prefixLabel].count;
    __block NSInteger index = 0;
    NSMutableArray *ranges = [NSMutableArray arrayWithCapacity:count];
    
    //解析html标签
    [self.comment.content enumerateStringsMatchedByRegex:[NSString stringWithFormat:@"%@.*?%@",prefixLabel,suffixLabel] usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        [ranges addObject:[Range rangeWithLocation:(*capturedRanges).location length:(*capturedRanges).length]];
        
        index++;
        
        if (count == index) {
            
            self.contentLabel.text = [self.contentLabel.text stringByReplacingOccurrencesOfString:prefixLabel withString:@""];
            self.contentLabel.text = [self.contentLabel.text stringByReplacingOccurrencesOfString:suffixLabel withString:@""];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentLabel.attributedText];
            
            for (NSInteger i = 0 ; i < count; i++) {
                
                Range *mrange = ranges[i];
                
                NSRange range;
                
                NSInteger labelLength = prefixLabel.length + suffixLabel.length;
                
                if (i == 0) {
                    range = NSMakeRange(mrange.location, mrange.length - labelLength);
                } else {
                    range = NSMakeRange(mrange.location - labelLength, mrange.length - labelLength);
                }
                
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:self.contentLabel.font.pointSize - 0.7f] range:range];
            }
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:kLineSpacing - 0.5f];//调整行间距
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, ((NSString *)self.contentLabel.text).length)];
            
            self.contentLabel.attributedText = attributedString;
            self.contentLabel.font = self.contentFont;
            
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
