//
//  XBSettingCell.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBSettingCell.h"

@implementation XBSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorHeightConstraint.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
