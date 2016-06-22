//
//  AboutConfig.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"
@class Item;
@interface AboutConfig : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSArray<Item *>   *itemList;
@property (strong, nonatomic) Item      *itemOnSideBar;
@end
