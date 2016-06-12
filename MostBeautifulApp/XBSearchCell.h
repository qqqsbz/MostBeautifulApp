//
//  SearchCell.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/8.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Search;
@interface XBSearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *separatorConstraint;

@property (strong, nonatomic) Search  *search;
@end
