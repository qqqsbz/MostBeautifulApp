//
//  XBDiscoverCell.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/12.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Discover;
@interface XBDiscoverCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *plantformLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *browseLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoriteLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewTopConstraint;

@property (strong, nonatomic) Discover  *discover;
@end
