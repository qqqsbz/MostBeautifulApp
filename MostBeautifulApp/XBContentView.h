//
//  XBContentView.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/30.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTTAttributedLabel;
@protocol XBContentViewDelegate <NSObject>

@optional
- (void)contentAttributedLabel:(TTTAttributedLabel *)label
          didSelectLinkWithURL:(NSURL *)url;

@end

typedef NS_ENUM(NSInteger,XBContentViewType) {
    XBContentViewTypeApp = 0,
    XBContentViewTypeDiscover
};
@interface XBContentView : UIView

@property (strong, nonatomic) NSString  *text;

@property (strong, nonatomic) NSString  *iconURLString;

@property (assign, nonatomic) XBContentViewType  type;

@property (weak, nonatomic) id<XBContentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)text type:(XBContentViewType)type;

@end
