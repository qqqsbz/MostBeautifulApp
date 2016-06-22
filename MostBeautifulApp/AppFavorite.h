//
//  AppFavorite.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/3.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "App.h"

@interface AppFavorite : App

@property (assign, nonatomic) BOOL    isFavorite;

@property (strong, nonatomic) NSDate  *updateAt;

+ (instancetype)favoriteAppFromApp:(App *)app;

- (BOOL)toggleFavoriteWithOutError:(NSError **)error;

@end
