//
//  SideMenu.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "SideMenu.h"
#import "Menu.h"
@implementation SideMenu

- (void)setMenuList:(NSArray<Menu *> *)menuList
{
    if ([menuList isKindOfClass:[NSSet class]]) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:menuList.count];
        NSSet *lists = (NSSet *)menuList;
        [lists enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [temp addObject:obj];
        }];
        menuList = temp;
    }
    
    //对结果进行倒序排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"_order"ascending:NO];
    
    NSArray *tempArray = [menuList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    _menuList = tempArray;
}

+ (NSString *)managedObjectEntityName
{
    return NSStringFromClass(self);
}

+ (NSDictionary *)managedObjectKeysByPropertyKey
{
    return @{};
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"menuList":@"menu_list"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"menuList":[Menu class]
             };
}

+ (NSValueTransformer *)menuListJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Menu class]];
}

@end
