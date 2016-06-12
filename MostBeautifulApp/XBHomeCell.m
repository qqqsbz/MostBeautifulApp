//
//  HomeCell.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBHomeCell.h"
#import "Info.h"
#import "NSIntegerFormatter.h"
@implementation XBHomeCell
- (void)awakeFromNib
{
    self.cellContentView.layer.masksToBounds = YES;
    self.cellContentView.layer.cornerRadius  = 4.f;
    
    self.favoriteView.layer.masksToBounds = YES;
    self.favoriteView.layer.cornerRadius  = 9.f;
    
    self.authorLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
}

- (void)setApp:(App *)app
{
    _app = app;
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",app.title,app.subTitle];
    self.subTitleLabel.hidden = YES;
    self.textView.text = app.digest;
    self.authorLabel.text = app.authorUsername;
    self.favoriteCountLabel.text = [NSIntegerFormatter formatToNSString:app.info.up];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:app.coverImage] placeholderImage:[UIImage imageNamed:@"home_logo_normal"]];
    
    NSRange titleRange = NSMakeRange(0, app.title.length);
    NSRange subTitleRange = NSMakeRange(titleRange.length + 1, app.subTitle.length);
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLabel.attributedText];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#6D6D6D"] range:titleRange];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20.f] range:titleRange];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#808080"] range:subTitleRange];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:15.f] range:subTitleRange];
    self.titleLabel.attributedText = attributeString;
    
}
@end
