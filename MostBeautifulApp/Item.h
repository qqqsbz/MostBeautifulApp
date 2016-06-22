//
//  Item.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Item : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSString  *title;
@property (strong, nonatomic) NSString  *detail;
@property (strong, nonatomic) NSString  *iconImage;
@property (assign, nonatomic) BOOL      onSideBar;
@property (strong, nonatomic) NSString  *titleConstantKey;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger order;
@end
