//
//  XBDiscoverBeautifulView.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/13.
//  Copyright © 2016年 coder. All rights reserved.
//
#define kDiscoverBeautifulHeight   130.f
#define kDiscoverBeautifulRowCount 8
#import <UIKit/UIKit.h>
@class XBDiscoverBeautifulView;
@protocol XBDiscoverBeautifulViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInBeautifulView;

- (NSString *)discoverBeautifulView:(XBDiscoverBeautifulView *)discoverBeautifulView itemForRowAtIndex:(NSInteger)index;
@end

@interface XBDiscoverBeautifulView : UIView

@property (weak, nonatomic) id<XBDiscoverBeautifulViewDataSource> datasource;

- (void)reloadData;

@end
