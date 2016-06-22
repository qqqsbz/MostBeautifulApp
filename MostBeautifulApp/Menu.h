//
//  Menu.h
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "Model.h"

@interface Menu : Model <MTLManagedObjectSerializing>
@property (strong, nonatomic) NSString  *name;
@property (strong, nonatomic) NSString  *iconUrl;
@property (assign, nonatomic) BOOL      canShow;
@property (strong, nonatomic) NSString  *verboseName;
@property (assign, nonatomic) NSInteger order;
@property (assign, nonatomic) BOOL      defaultOpen;

@end
