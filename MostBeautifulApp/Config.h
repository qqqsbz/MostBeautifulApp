//
//  Config.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"
@class SideMenu;
@class AboutConfig;
@interface Config : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) SideMenu      *sideMenu;
@property (strong, nonatomic) AboutConfig   *aboutConfig;
@end
