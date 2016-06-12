//
//  DBUtil.h
//  iPenYou
//
//  Created by coder on 16/3/15.
//  Copyright © 2016年 vbuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

typedef void(^Complete)(NSArray *datas);
typedef void(^OneComplete)(id result);
@interface DBUtil : NSObject

+ (instancetype)shareDBUtil;

- (BOOL)add:(MTLModel<MTLManagedObjectSerializing> *)model;

- (void)update:(MTLModel<MTLManagedObjectSerializing> *)model;

- (void)remove:(NSManagedObject *)model;

- (void)queryListWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors complete:(Complete)complete;

- (void)queryOneWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors complete:(OneComplete)complete;
@end
