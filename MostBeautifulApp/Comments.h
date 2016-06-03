//
//  Comments.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Comments : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSArray   *data;
@property (assign, nonatomic) NSInteger hasNext;
@end
