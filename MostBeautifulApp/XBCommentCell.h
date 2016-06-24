//
//  XBCommentCell.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/2.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XBCommentCellDelegate <NSObject>

@optional
- (void)commentCellDidSelectLinkWithURL:(NSURL *)url;

@end

@class Comment;
@class TTTAttributedLabel;
@interface XBCommentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *signLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bubbleImageView;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@property (strong, nonatomic) Comment  *comment;
@property (strong, nonatomic) UIFont   *contentFont;
@property (weak, nonatomic) id<XBCommentCellDelegate> delegate;
@end