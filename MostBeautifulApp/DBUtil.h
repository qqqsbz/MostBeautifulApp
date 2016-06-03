//
//  DBUtil.h
//  iPenYou
//
//  Created by coder on 16/3/15.
//  Copyright © 2016年 vbuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
@interface DBUtil : NSObject

+ (instancetype)shareDBUtil;

- (BOOL)add:(MTLModel<MTLManagedObjectSerializing> *)model;

- (void)update:(MTLModel<MTLManagedObjectSerializing> *)model;

- (void)remove:(NSManagedObject *)model;

- (NSArray *)queryListWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;

- (id)queryOneWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
@end
