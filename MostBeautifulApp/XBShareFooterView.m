//
//  ShareFooterView.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "XBShareFooterView.h"

@implementation XBShareFooterView

- (void)awakeFromNib
{
    self.dismissButton.layer.masksToBounds = YES;
    self.dismissButton.layer.cornerRadius  = 5.f;
}

- (IBAction)dissmissAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didDismissHandler)]) {
        [self.delegate didDismissHandler];
    }
}

@end
