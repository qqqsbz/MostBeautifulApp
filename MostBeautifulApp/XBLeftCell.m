//
//  LeftCell.m
//  MostBeautifulApp
//
//  Created by coder on 16/5/23.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBLeftCell.h"

@implementation XBLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
