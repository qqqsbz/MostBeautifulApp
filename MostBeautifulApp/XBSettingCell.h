//
//  XBSettingCell.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/7.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XBSettingCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separatorHeightConstraint;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;
@end
