//
//  DBUtil.m
//  iPenYou
//
//  Created by coder on 16/3/15.
//  Copyright © 2016年 vbuy. All rights reserved.
//

#import "DBUtil.h"
#import "Application.h"
#import "Model.h"
@interface DBUtil()

@property (strong, nonatomic) NSFetchedResultsController  *fetchedResultsController;

@property (strong, nonatomic) NSFetchRequest  *fetchRequest;

@end
@implementation DBUtil

+ (instancetype)shareDBUtil
{
    static DBUtil *util;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        util = [[DBUtil alloc] init];
        util.fetchRequest = [[NSFetchRequest alloc] init];
    });
    return util;
}

- (BOOL)add:(MTLModel<MTLManagedObjectSerializing> *)model
{
    NSError *error;
    NSManagedObject *managedObject = [MTLManagedObjectAdapter managedObjectFromModel:model insertingIntoContext:[Application sharedManagedObjectContext] error:&error];
    if (managedObject) {
        [Application saveSharedManagedObjectContext];
        return true;
    }
    return NO;
}

- (void)update:(MTLModel<MTLManagedObjectSerializing> *)model
{
    [Application saveSharedManagedObjectContext];
}

- (void)remove:(NSManagedObject *)model
{
    [Application deleteShareManagedObjectContext:model];
    NSError *error;
    [Application saveSharedManagedObjectContext];
    if (error) {
        DDLogCDebug(@"delete data error:%@",error);
    }
}

- (void)queryListWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors complete:(Complete)complete
{
    NSManagedObjectContext *moc = [Application sharedManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    if (!fetchRequest) {
        fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.fetchLimit = 100;
    }
    
    fetchRequest.entity = entity;
    
    if (sortDescriptors && sortDescriptors.count > 0) {
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:fetchRequest error:&error];
    if (error) {
        DDLogCDebug(@"query list from core data error:%@",error);
    }
    
    complete(result);

}

- (void)queryOneWithEntityName:(NSString *)entityName fetchRequest:(NSFetchRequest *)fetchRequest sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors complete:(OneComplete)complete
{
    NSManagedObjectContext *moc = [Application sharedManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    if (!fetchRequest) {
        fetchRequest = self.fetchRequest;
    }
    fetchRequest.entity = entity;
    fetchRequest.fetchLimit = 1;
    if (sortDescriptors && sortDescriptors.count > 0) {
        fetchRequest.sortDescriptors = sortDescriptors;
    }
    NSError *error = nil;
    id result = [[moc executeFetchRequest:fetchRequest error:&error] lastObject];
    if (error) {
        DDLogCDebug(@"query one from core data error:%@",error);
    } else {
        complete(result);
    }
}
@end
