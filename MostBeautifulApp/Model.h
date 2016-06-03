//
//  Model.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>

@interface Model : MTLModel <MTLJSONSerializing>
@property(copy, nonatomic) NSString *modelId;
@end
