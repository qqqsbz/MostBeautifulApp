//
//  AboutConfig.m
//  MostBeautifulApp
//
//  Created by coder on 16/6/22.
//  Copyright © 2016年 coder. All rights reserved.
//

#import "AboutConfig.h"
#import "Item.h"
@implementation AboutConfig

- (void)setItemList:(NSArray<Item *> *)itemList
{
    if ([itemList isKindOfClass:[NSSet class]]) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:itemList.count];
        NSSet *lists = (NSSet *)itemList;
        [lists enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            [temp addObject:obj];
        }];
        itemList = temp;
    }
    _itemList = itemList;
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
    return @{@"itemList":@"item_list",
             @"itemOnSideBar":@"item_on_sidebar"
             };
}

+ (NSDictionary *)relationshipModelClassesByPropertyKey
{
    return @{@"itemList":[Item class],
             @"itemOnSideBar":[Item class]
             };
}

+ (NSValueTransformer *)itemListJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Item class]];
}

+ (NSValueTransformer *)itemOnSideBarJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[Item class]];
}

@end
