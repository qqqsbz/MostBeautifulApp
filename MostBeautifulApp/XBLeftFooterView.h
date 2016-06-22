//
//  LeftFooterView.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftFooterViewDelegate <NSObject>

@optional
- (void)didSelectedLeftButton:(UIButton *)sender;

- (void)didSelectedTitleButton:(UIButton *)sender;

- (void)didSelectedRightButton:(UIButton *)sender;

@end

@interface XBLeftFooterView : UIView

/** 标题按钮设置标题 */
@property (strong, nonatomic) NSString  *title;

/** 标题按钮是否可用 */
@property (assign, nonatomic) BOOL      titleEnable;

@property (weak, nonatomic) id<LeftFooterViewDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame leftImage:(UIImage *)leftImage title:(NSString *)title rightImage:(UIImage *)rightImage;

@end
