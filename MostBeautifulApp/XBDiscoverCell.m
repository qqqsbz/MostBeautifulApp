//
//  XBDiscoverCell.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBDiscoverCell.h"
#import "Discover.h"
#import "DiscoverComment.h"
#import "NSIntegerFormatter.h"
@implementation XBDiscoverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius  = 4.f;
    
    self.avatorImageView.layer.masksToBounds = YES;
    self.avatorImageView.layer.cornerRadius  = CGRectGetWidth(self.avatorImageView.frame) / 2.f;
 
    self.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
    self.coverImageView.layer.borderWidth = 1.f;
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius  = 4.f;
    
    CGRect frame  = [self.avatorImageView convertRect:self.avatorImageView.bounds toView:self.contentView];
    CGPoint point = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:point radius:CGRectGetWidth(self.avatorImageView.frame) / 2.f + 3 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor     = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor   = [UIColor colorWithHexString:@"#EFEEEF"].CGColor;
    shapeLayer.lineWidth     = 1.f;
    shapeLayer.path          = bezierPath.CGPath;
    [self.layer addSublayer:shapeLayer];
    
}

- (void)setDiscover:(Discover *)discover
{
    _discover = discover;
    self.nameLabel.text = discover.authorName;
    self.plantformLabel.text = discover.authorCareer;
    self.titleLabel.text = discover.appName;
    self.contentLabel.text = [discover.desc stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    self.browseLabel.text = [NSIntegerFormatter formatToNSString:discover.showTimes];
    self.favoriteLabel.text  = [NSIntegerFormatter formatToNSString:discover.upTimes];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:discover.iconImage]];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:discover.coverImage]];
    [self.avatorImageView sd_setImageWithURL:[NSURL URLWithString:discover.authorAvatarUrl]];
    
    if (discover.comments.count > 0) {
        DiscoverComment *comment = [discover.comments firstObject];
        self.commentLabel.text = [NSIntegerFormatter formatToNSString:comment.count];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
