//
//  XBCommentCell.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/2.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBCommentCell.h"
#import "UIImage+Util.h"
#import "Comment.h"
#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel+AnalysisHTMLTag.h"
@interface XBCommentCell() <TTTAttributedLabelDelegate>
@end
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
    self.contentLabel.delegate = self;
    
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
    
    [self.contentLabel analysisHTMLLinkWithText:@"点击查看"];

    [self.contentLabel analysisHTMLTagWithPrefixTag:@"<strong>" suffixTag:@"</strong>" analysisingBlock:^(NSMutableAttributedString *attributedString, NSRange range) {
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:self.contentLabel.font.pointSize - 1.2] range:range];
        
    } complete:^(NSMutableAttributedString *attributedString) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:kLineSpacing - 0.5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, ((NSString *)self.contentLabel.text).length)];
    
    } ];
}

#pragma mark -- TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(commentCellDidSelectLinkWithURL:)]) {
        [self.delegate commentCellDidSelectLinkWithURL:url];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
