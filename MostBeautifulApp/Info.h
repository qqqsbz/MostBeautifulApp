//
//  Info.h
//  MostBeautifulApp
//
//  Created by coder on 16/5/24.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Info : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSArray   *upUsers;
@property (strong, nonatomic) NSArray   *favUsers;
@property (strong, nonatomic) NSString  *fav;
@property (strong, nonatomic) NSString  *up;
@property (strong, nonatomic) NSString  *down;
@property (strong, nonatomic) NSString  *av;
@property (strong, nonatomic) NSArray   *downUsers;
@end
