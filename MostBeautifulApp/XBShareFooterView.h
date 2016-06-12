//
//  ShareFooterView.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XBShareFooterViewDelegate <NSObject>

@optional
- (void)didDismissHandler;

@end

@interface XBShareFooterView : UICollectionReusableView

@property (strong, nonatomic) IBOutlet UIButton *dismissButton;

@property (weak, nonatomic) id<XBShareFooterViewDelegate> delegate;

@end

