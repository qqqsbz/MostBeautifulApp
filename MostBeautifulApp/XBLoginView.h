//
//  LoginView.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/6.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XBLoginViewDelegate <NSObject>

@optional
- (void)loginViewdDidSelectedLogin;

- (void)loginViewDidSelectedProtocol;

- (void)loginViewDidDismiss;

@end
@interface XBLoginView : UIView

@property (weak, nonatomic) id<XBLoginViewDelegate> delegate;

@end
