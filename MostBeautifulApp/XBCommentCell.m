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
@implementation XBCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius  = CGRectGetWidth(self.avatorImageView.frame) / 2.f;
    
    self.avatorImageView.layer.borderColor = [UIColor colorWithHexString:@"#CECFD1"].CGColor;
    self.avatorImageView.layer.borderWidth = 2.f;
    
    UIImage *image = [UIImage resizeImageWithImageName:@"detail_comment_bg"];
    self.bubbleImageView.image = image;
    
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
    self.signLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.f];
    
    self.contentLabel.numberOfLines = 0.;
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    
    self.nameLabel.text = comment.authorName;
    self.signLabel.text = comment.authorCareer;
    self.timeLabel.text = [comment.createdAt substringFromIndex:2];
    NSString *content = [comment.content stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    self.contentLabel.text = content;
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:comment.authorAvatarUrl]];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.f];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.contentLabel.attributedText = attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
