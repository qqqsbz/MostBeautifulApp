//
//  SearchCell.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSearchCell.h"
#import "Search.h"
@implementation XBSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.layer.cornerRadius  = 8.f;
    
//    self.separatorConstraint.constant = 0.7f;
}

- (void)setSearch:(Search *)search
{
    _search = search;
    
    self.titleLabel.text = self.search.title;
    self.subTitleLabel.text = self.search.subTitle;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:self.search.iconUrl]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
