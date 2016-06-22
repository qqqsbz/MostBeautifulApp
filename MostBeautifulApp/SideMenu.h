//
//  SideMenu.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"
@class Menu;
@interface SideMenu : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSArray<Menu *>  *menuList;
@end
