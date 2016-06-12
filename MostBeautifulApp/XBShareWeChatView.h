//
//  XBShareWeChatView.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/31.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XBShareWeChatViewDelegate <NSObject>

@optional
- (void)shareWeChatViewDidSelected;

@end
@interface XBShareWeChatView : UIView

@property (weak, nonatomic) id<XBShareWeChatViewDelegate> delegate;

@end
