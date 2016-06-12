//
//  RecruitToolBar.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/4.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XBRecruitToolBarDelegate <NSObject>

@optional
- (void)didSelectedForword:(UIButton *)sender;

- (void)didSelectedBack:(UIButton *)sender;

- (void)didSelectedRefresh:(UIButton *)sender;

- (void)didSelectedShare:(UIButton *)sender;

@end
@interface XBRecruitToolBar : UIView

@property (weak, nonatomic) id<XBRecruitToolBarDelegate> delegate;

@end
