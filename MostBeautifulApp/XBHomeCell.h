//
//  HomeCell.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
@interface XBHomeCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIView *cellContentView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coverImageView;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIView *favoriteView;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCountLabel;

@property (strong, nonatomic) App  *app;
@end
