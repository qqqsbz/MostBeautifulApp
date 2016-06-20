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
@property (assign, nonatomic) NSInteger up;
@property (assign, nonatomic) NSInteger down;
@property (assign, nonatomic) NSInteger av;
@property (strong, nonatomic) NSArray   *downUsers;
@property (strong, nonatomic) NSString  *upUsersDetail;

- (NSArray *)unarchiveObjectWithDataFromUpUsers;

- (NSArray *)unarchiveObjectWithDataFromDownUsers;

- (NSArray *)unarchiveObjectWithDataFromFavUsers;

@end
